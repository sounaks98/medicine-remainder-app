package com.medicinereminder.medicine_remainder_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
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
    }
}
