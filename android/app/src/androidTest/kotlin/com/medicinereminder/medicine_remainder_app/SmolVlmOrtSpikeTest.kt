package com.medicinereminder.medicine_remainder_app

import android.content.Context
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File

/**
 * P2-05/P2-06: Load all three q4f16 ONNX sessions on device/emulator.
 *
 * Push weights before running:
 *   adb shell mkdir -p /data/local/tmp/smolvlm_spike
 *   adb push each q4f16 .onnx from tool/model_spike/ into /data/local/tmp/smolvlm_spike/
 */
@RunWith(AndroidJUnit4::class)
class SmolVlmOrtSpikeTest {
    private val onnxNames =
        listOf(
            "vision_encoder_q4f16.onnx",
            "embed_tokens_q4f16.onnx",
            "decoder_model_merged_q4f16.onnx",
        )

    @Test
    fun probeAllOnnxSessions() {
        val context = InstrumentationRegistry.getInstrumentation().targetContext
        val modelDir = stageModelsFromTmp(context)
        assertTrue(
            "Missing staged models under ${modelDir.absolutePath}",
            modelDir.isDirectory && onnxNames.all { File(modelDir, it).isFile },
        )

        val result = SmolVlmOnnxBridge.probeSessions(context, modelDir.absolutePath)
        val models = result["models"] as List<*>
        assertEquals(3, models.size)
        for (entry in models) {
            val map = entry as Map<*, *>
            assertTrue((map["loadMs"] as Long) >= 0)
        }
    }

    private fun stageModelsFromTmp(context: Context): File {
        val dest = File(context.getExternalFilesDir(null), "smolvlm_spike")
        dest.mkdirs()
        val src = File("/data/local/tmp/smolvlm_spike")
        for (name in onnxNames) {
            val out = File(dest, name)
            if (out.isFile && out.length() > 0L) {
                continue
            }
            val staged = File(src, name)
            assertTrue(
                "Push $name to ${src.absolutePath} before running this test",
                staged.isFile,
            )
            staged.inputStream().use { input ->
                out.outputStream().use { output -> input.copyTo(output) }
            }
        }
        return dest
    }
}
