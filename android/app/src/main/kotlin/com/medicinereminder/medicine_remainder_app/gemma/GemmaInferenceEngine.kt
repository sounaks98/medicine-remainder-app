package com.medicinereminder.medicine_remainder_app.gemma

import android.util.Log
import com.google.ai.edge.litertlm.Content
import com.google.ai.edge.litertlm.Contents
import com.google.ai.edge.litertlm.Conversation
import com.google.ai.edge.litertlm.ConversationConfig
import com.google.ai.edge.litertlm.Message
import com.google.ai.edge.litertlm.MessageCallback
import com.google.ai.edge.litertlm.SamplerConfig
import java.io.File
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicReference

class GemmaInferenceEngine(private val modelManager: GemmaModelManager) {
    @Volatile
    private var activeConversation: Conversation? = null

    fun processPrescriptionImage(
        imagePath: String,
        systemPrompt: String,
        userPrompt: String,
        onPartialText: (String) -> Unit,
    ): String {
        val prepared = GemmaImagePreprocessor.prepareForInference(imagePath)
        try {
            return runVisionOrText(
                imageFile = prepared,
                systemPrompt = systemPrompt,
                userPrompt = userPrompt,
                onPartialText = onPartialText,
            )
        } finally {
            prepared.delete()
        }
    }

    fun processPrescriptionText(
        systemPrompt: String,
        userPrompt: String,
        onPartialText: (String) -> Unit,
    ): String {
        return runVisionOrText(
            imageFile = null,
            systemPrompt = systemPrompt,
            userPrompt = userPrompt,
            onPartialText = onPartialText,
        )
    }

    fun cancelInference() {
        val conversation = activeConversation
        if (conversation != null) {
            try {
                conversation.close()
            } catch (error: Throwable) {
                Log.w(TAG, "close conversation on cancel", error)
            }
        }
        activeConversation = null
    }

    private fun runVisionOrText(
        imageFile: File?,
        systemPrompt: String,
        userPrompt: String,
        onPartialText: (String) -> Unit,
    ): String {
        val engine = modelManager.getEngine()
        if (imageFile != null && modelManager.backendLabel() == "CPU_TEXT_ONLY") {
            throw IllegalStateException(
                "Gemma vision backend is unavailable on this device; cannot read prescription images.",
            )
        }
        val canUseVision = imageFile != null

        val sampler =
            SamplerConfig(
                topK = 64,
                topP = 0.95,
                temperature = 0.2,
            )
        val conversation =
            engine.createConversation(
                ConversationConfig(
                    systemInstruction = Contents.of(systemPrompt),
                    samplerConfig = sampler,
                    maxOutputToken = 2048,
                ),
            )
        activeConversation = conversation

        val contents =
            if (canUseVision) {
                Contents.of(
                    Content.Text(userPrompt),
                    Content.ImageFile(imageFile!!.absolutePath),
                )
            } else {
                Contents.of(Content.Text(userPrompt))
            }

        val latch = CountDownLatch(1)
        val buffer = StringBuilder()
        val errorRef = AtomicReference<Throwable?>(null)

        try {
            conversation.sendMessageAsync(
                Message.user(contents),
                object : MessageCallback {
                    override fun onMessage(message: Message) {
                        for (content in message.contents.contents) {
                            if (content is Content.Text) {
                                buffer.append(content.text)
                                onPartialText(content.text)
                            }
                        }
                    }

                    override fun onDone() {
                        latch.countDown()
                    }

                    override fun onError(throwable: Throwable) {
                        errorRef.set(throwable)
                        latch.countDown()
                    }
                },
            )

            if (!latch.await(20, TimeUnit.MINUTES)) {
                throw IllegalStateException("Gemma inference timed out")
            }
            errorRef.get()?.let { throw it }

            val text = buffer.toString()
            if (text.isBlank()) {
                throw IllegalStateException("Gemma returned empty text")
            }
            return text
        } finally {
            try {
                conversation.close()
            } catch (_: Throwable) {
            }
            if (activeConversation === conversation) {
                activeConversation = null
            }
        }
    }

    companion object {
        private const val TAG = "GemmaInferenceEngine"
    }
}
