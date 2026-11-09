package com.medicinereminder.medicine_remainder_app.gemma

import android.content.Context
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class GemmaPlatformChannel(context: Context) :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {
    private val appContext = context.applicationContext
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private val chunkInstaller = GemmaChunkInstaller(appContext)
    private val modelManager = GemmaModelManager(appContext)
    private val inferenceEngine = GemmaInferenceEngine(modelManager)

    private var eventSink: EventChannel.EventSink? = null
    private var cachedChecksum: GemmaChecksumMetadata? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkModelStatus" -> handleCheckModelStatus(result)
            "getModelInformation" -> handleGetModelInformation(result)
            "initializeModel" -> handleInitializeModel(result)
            "processPrescriptionImage" -> handleProcessImage(call, result)
            "processPrescriptionText" -> handleProcessText(call, result)
            "cancelInference" -> {
                inferenceEngine.cancelInference()
                result.success(null)
            }
            "releaseModel" ->
                scope.launch {
                    modelManager.release()
                    withContext(Dispatchers.Main) { result.success(null) }
                }
            "materializeModel" -> handleMaterializeModel(result)
            else -> result.notImplemented()
        }
    }

    fun onTrimMemory() {
        scope.launch {
            modelManager.release()
        }
    }

    fun dispose() {
        scope.cancel()
        inferenceEngine.cancelInference()
    }

    private fun emit(event: String, data: Map<String, Any?> = emptyMap()) {
        scope.launch(Dispatchers.Main.immediate) {
            val sink = eventSink ?: return@launch
            sink.success(
                mapOf(
                    "event" to event,
                    "data" to data,
                ),
            )
        }
    }

    private fun handleCheckModelStatus(result: MethodChannel.Result) {
        scope.launch {
            try {
                val status = buildStatus()
                withContext(Dispatchers.Main) { result.success(status) }
            } catch (error: Throwable) {
                withContext(Dispatchers.Main) {
                    result.success(
                        mapOf(
                            "packaged" to false,
                            "materialized" to false,
                            "engineReady" to false,
                            "error" to (error.message ?: error.toString()),
                        ),
                    )
                }
            }
        }
    }

    private suspend fun buildStatus(): Map<String, Any?> {
        return withContext(Dispatchers.IO) {
            buildStatusOnIo()
        }
    }

    private fun buildStatusOnIo(): Map<String, Any?> {
        val checksum = readChecksumOrNull()
        val packaged = checksum != null
        val materialized =
            if (checksum != null) chunkInstaller.isModelMaterialized(checksum) else false
        return mapOf(
            "packaged" to packaged,
            "materialized" to materialized,
            "engineReady" to modelManager.isInitialized(),
            "arm64" to GemmaDeviceGate.supportsArm64(),
            "compatibilityError" to GemmaDeviceGate.compatibilityError(appContext),
            "expectedSha256" to checksum?.sha256,
            "expectedSizeBytes" to checksum?.sizeBytes,
        )
    }

    private fun handleGetModelInformation(result: MethodChannel.Result) {
        scope.launch {
            val checksum = withContext(Dispatchers.IO) { readChecksumOrNull() }
            val info =
                mapOf(
                    "artifact" to (checksum?.artifactName ?: GemmaConstants.MODEL_FILE_NAME),
                    "backend" to modelManager.backendLabel(),
                    "chunkCount" to (checksum?.chunkCount ?: 0),
                    "packaged" to (checksum != null),
                )
            withContext(Dispatchers.Main) { result.success(info) }
        }
    }

    private fun handleMaterializeModel(result: MethodChannel.Result) {
        scope.launch {
            try {
                GemmaDeviceGate.compatibilityError(appContext)?.let { message ->
                    throw IllegalStateException(message)
                }
                val checksum = requireChecksum()
                emit("modelInitializationProgress", mapOf("fraction" to 0.0))
                val path =
                    withContext(Dispatchers.IO) {
                        chunkInstaller.ensureModelInstalled(checksum) { fraction ->
                            emit(
                                "modelInitializationProgress",
                                mapOf("fraction" to fraction),
                            )
                        }
                    }
                withContext(Dispatchers.Main) {
                    result.success(mapOf("modelPath" to path))
                }
            } catch (error: Throwable) {
                emit("inferenceError", mapOf("message" to error.message))
                withContext(Dispatchers.Main) {
                    result.error("MODEL", error.message, error.toString())
                }
            }
        }
    }

    private fun handleInitializeModel(result: MethodChannel.Result) {
        scope.launch {
            try {
                GemmaDeviceGate.compatibilityError(appContext)?.let { message ->
                    throw IllegalStateException(message)
                }
                val checksum = requireChecksum()
                emit("modelInitializationProgress", mapOf("fraction" to 0.0, "stage" to "materialize"))
                val modelPath =
                    withContext(Dispatchers.IO) {
                        chunkInstaller.ensureModelInstalled(checksum) { fraction ->
                            emit(
                                "modelInitializationProgress",
                                mapOf("fraction" to fraction, "stage" to "materialize"),
                            )
                        }
                    }
                emit(
                    "modelInitializationProgress",
                    mapOf("fraction" to 1.0, "stage" to "engine"),
                )
                withContext(Dispatchers.IO) {
                    modelManager.initialize(modelPath)
                }
                emit(
                    "modelInitializationProgress",
                    mapOf("fraction" to 1.0, "stage" to "ready"),
                )
                withContext(Dispatchers.Main) {
                    result.success(
                        mapOf(
                            "ready" to true,
                            "backend" to modelManager.backendLabel(),
                            "modelPath" to modelPath,
                        ),
                    )
                }
            } catch (error: Throwable) {
                emit("inferenceError", mapOf("message" to error.message))
                withContext(Dispatchers.Main) {
                    result.error("INIT", error.message, error.toString())
                }
            }
        }
    }

    private fun handleProcessImage(call: MethodCall, result: MethodChannel.Result) {
        val imagePath = call.argument<String>("imagePath")
        val systemPrompt = call.argument<String>("systemPrompt")
        val userPrompt = call.argument<String>("userPrompt")
        if (imagePath.isNullOrBlank() || systemPrompt.isNullOrBlank() || userPrompt.isNullOrBlank()) {
            result.error("ARG", "imagePath, systemPrompt, userPrompt required", null)
            return
        }

        scope.launch {
            try {
                emit("inferenceProgress", mapOf("stage" to "started"))
                val raw =
                    withContext(Dispatchers.IO) {
                        inferenceEngine.processPrescriptionImage(
                            imagePath = imagePath,
                            systemPrompt = systemPrompt,
                            userPrompt = userPrompt,
                            onPartialText = { token ->
                                emit("generatedText", mapOf("token" to token))
                            },
                        )
                    }
                val parsed = parseWithOptionalRepair(raw, systemPrompt, userPrompt, imagePath)
                emit(
                    "inferenceCompleted",
                    mapOf(
                        "rawText" to raw,
                        "json" to parsed,
                    ),
                )
                withContext(Dispatchers.Main) { result.success(parsed) }
            } catch (error: Throwable) {
                emit("inferenceError", mapOf("message" to error.message))
                withContext(Dispatchers.Main) {
                    result.error("INFER", error.message, error.toString())
                }
            }
        }
    }

    private fun handleProcessText(call: MethodCall, result: MethodChannel.Result) {
        val systemPrompt = call.argument<String>("systemPrompt")
        val userPrompt = call.argument<String>("userPrompt")
        if (systemPrompt.isNullOrBlank() || userPrompt.isNullOrBlank()) {
            result.error("ARG", "systemPrompt and userPrompt required", null)
            return
        }

        scope.launch {
            try {
                val raw =
                    withContext(Dispatchers.IO) {
                        inferenceEngine.processPrescriptionText(
                            systemPrompt = systemPrompt,
                            userPrompt = userPrompt,
                            onPartialText = { token ->
                                emit("generatedText", mapOf("token" to token))
                            },
                        )
                    }
                val json = GemmaResultHandler.toResultMap(GemmaResultHandler.parsePrescriptionJson(raw))
                emit("inferenceCompleted", mapOf("rawText" to raw, "json" to json))
                withContext(Dispatchers.Main) { result.success(json) }
            } catch (error: Throwable) {
                emit("inferenceError", mapOf("message" to error.message))
                withContext(Dispatchers.Main) {
                    result.error("INFER", error.message, error.toString())
                }
            }
        }
    }

    private suspend fun parseWithOptionalRepair(
        raw: String,
        systemPrompt: String,
        userPrompt: String,
        imagePath: String,
    ): Map<String, Any?> {
        return try {
            GemmaResultHandler.toResultMap(GemmaResultHandler.parsePrescriptionJson(raw))
        } catch (firstError: Throwable) {
            val repairPrompt =
                "$userPrompt\n\nReturn only valid JSON matching the schema. No markdown, no commentary."
            val repairedRaw =
                withContext(Dispatchers.IO) {
                    inferenceEngine.processPrescriptionImage(
                        imagePath = imagePath,
                        systemPrompt = systemPrompt,
                        userPrompt = repairPrompt,
                        onPartialText = {},
                    )
                }
            GemmaResultHandler.toResultMap(GemmaResultHandler.parsePrescriptionJson(repairedRaw))
        }
    }

    private fun readChecksumOrNull(): GemmaChecksumMetadata? {
        cachedChecksum?.let { return it }
        return try {
            chunkInstaller.readChecksumFromAssets().also { cachedChecksum = it }
        } catch (_: Exception) {
            null
        }
    }

    private fun requireChecksum(): GemmaChecksumMetadata {
        return readChecksumOrNull()
            ?: throw IllegalStateException("Gemma model not packaged in this build")
    }
}
