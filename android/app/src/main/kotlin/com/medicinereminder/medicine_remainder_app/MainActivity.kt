package com.medicinereminder.medicine_remainder_app

import android.content.ComponentCallbacks2
import com.medicinereminder.medicine_remainder_app.gemma.GemmaConstants
import com.medicinereminder.medicine_remainder_app.gemma.GemmaPlatformChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var gemmaChannel: GemmaPlatformChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "medicine_remainder_app/smolvlm_onnx_spike",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "probeSessions" -> {
                    val modelDir = call.argument<String>("modelDir")
                    if (modelDir.isNullOrBlank()) {
                        result.error("ARG", "modelDir required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val payload = SmolVlmOnnxBridge.probeSessions(applicationContext, modelDir)
                        result.success(payload)
                    } catch (e: Exception) {
                        result.error("ORT_LOAD", e.message, e.toString())
                    }
                }
                else -> result.notImplemented()
            }
        }

        val gemma = GemmaPlatformChannel(applicationContext)
        gemmaChannel = gemma
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GemmaConstants.CHANNEL,
        ).setMethodCallHandler(gemma)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            GemmaConstants.EVENT_CHANNEL,
        ).setStreamHandler(gemma)
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        if (level >= ComponentCallbacks2.TRIM_MEMORY_BACKGROUND) {
            gemmaChannel?.onTrimMemory()
        }
    }

    override fun onDestroy() {
        gemmaChannel?.dispose()
        gemmaChannel = null
        super.onDestroy()
    }
}
