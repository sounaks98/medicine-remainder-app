package com.medicinereminder.medicine_remainder_app

import android.app.ActivityManager
import android.content.Context
import android.os.Debug
import android.os.SystemClock
import android.util.Log
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import java.io.File

/**
 * Phase 2 spike: load each SmolVLM q4f16 ONNX subgraph with ONNX Runtime Android.
 */
object SmolVlmOnnxBridge {
    private const val TAG = "SmolVlmOnnxSpike"

    private val onnxFiles =
        listOf(
            "vision_encoder_q4f16.onnx",
            "embed_tokens_q4f16.onnx",
            "decoder_model_merged_q4f16.onnx",
        )

    fun probeSessions(context: Context, modelDir: String): Map<String, Any> {
        val dir = File(modelDir)
        if (!dir.isDirectory) {
            throw IllegalArgumentException("modelDir is not a directory: $modelDir")
        }

        val env = OrtEnvironment.getEnvironment()
        val perModel = mutableListOf<Map<String, Any>>()
        val t0 = SystemClock.elapsedRealtime()

        for (name in onnxFiles) {
            val path = File(dir, name)
            if (!path.isFile()) {
                throw IllegalStateException("Missing ONNX file: ${path.absolutePath}")
            }
            val loadStart = SystemClock.elapsedRealtime()
            val sessionOptions = OrtSession.SessionOptions()
            sessionOptions.setIntraOpNumThreads(2)
            sessionOptions.setInterOpNumThreads(1)
            val session = env.createSession(path.absolutePath, sessionOptions)
            val loadMs = SystemClock.elapsedRealtime() - loadStart
            val inputs =
                session.inputNames.map { inputName ->
                    val info = session.inputInfo[inputName]
                    mapOf(
                        "name" to inputName,
                        "type" to (info?.info?.toString() ?: "unknown"),
                    )
                }
            val outputs =
                session.outputNames.map { outputName ->
                    mapOf("name" to outputName)
                }
            session.close()
            Log.i(TAG, "loaded $name in ${loadMs}ms inputs=${inputs.size} outputs=${outputs.size}")
            perModel.add(
                mapOf(
                    "file" to name,
                    "sizeBytes" to path.length(),
                    "loadMs" to loadMs,
                    "inputs" to inputs,
                    "outputs" to outputs,
                ),
            )
        }

        val totalMs = SystemClock.elapsedRealtime() - t0
        val mem = currentMemoryMb(context)
        Log.i(
            TAG,
            "probe complete totalMs=$totalMs pssMb=${mem["pssMb"]} javaHeapMb=${mem["javaHeapMb"]}",
        )

        return mapOf(
            "modelDir" to dir.absolutePath,
            "ortVersion" to OrtEnvironment.getEnvironment().version,
            "models" to perModel,
            "totalLoadMs" to totalMs,
            "memory" to mem,
        )
    }

    private fun currentMemoryMb(context: Context): Map<String, Long> {
        val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val pid = android.os.Process.myPid()
        val info = am.getProcessMemoryInfo(intArrayOf(pid)).firstOrNull()
        val pssKb = info?.totalPss?.toLong() ?: 0L
        val runtime = Runtime.getRuntime()
        val javaUsed = (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024)
        val nativeAllocated = Debug.getNativeHeapAllocatedSize() / (1024 * 1024)
        return mapOf(
            "pssMb" to pssKb / 1024,
            "javaHeapMb" to javaUsed,
            "nativeHeapMb" to nativeAllocated,
        )
    }
}
