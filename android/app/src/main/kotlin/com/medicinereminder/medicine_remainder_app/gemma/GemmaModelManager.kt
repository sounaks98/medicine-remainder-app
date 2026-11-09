package com.medicinereminder.medicine_remainder_app.gemma

import android.content.Context
import android.util.Log
import com.google.ai.edge.litertlm.Backend
import com.google.ai.edge.litertlm.Engine
import com.google.ai.edge.litertlm.EngineConfig
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

class GemmaModelManager(private val context: Context) {
    private val mutex = Mutex()
    private var engine: Engine? = null
    private var activeBackend: String = "none"
    private var modelPath: String? = null

    suspend fun initialize(modelPath: String) = mutex.withLock {
        if (engine?.isInitialized() == true && this.modelPath == modelPath) {
            return@withLock
        }
        releaseLocked()

        val cacheDir = context.cacheDir.absolutePath
        val errors = mutableListOf<String>()

        // CPU multimodal first: many Mali devices fail GPU vision init.
        val attempts =
            listOf(
                Triple(Backend.CPU(), Backend.CPU(), "CPU"),
                Triple(Backend.GPU(), Backend.GPU(), "GPU"),
            )

        for ((backend, visionBackend, label) in attempts) {
            try {
                val config =
                    EngineConfig(
                        modelPath = modelPath,
                        backend = backend,
                        visionBackend = visionBackend,
                        audioBackend = if (visionBackend != null) Backend.CPU() else null,
                        maxNumTokens = GemmaConstants.MAX_NUM_TOKENS,
                        maxNumImages = 1,
                        cacheDir = cacheDir,
                    )
                val newEngine = Engine(config)
                newEngine.initialize()
                engine = newEngine
                this.modelPath = modelPath
                activeBackend = if (visionBackend == null) "CPU_TEXT_ONLY" else label
                Log.i(TAG, "Gemma engine initialized on $activeBackend")
                return@withLock
            } catch (error: Throwable) {
                errors += "$label: ${error.message ?: error.javaClass.simpleName}"
                Log.w(TAG, "Gemma init attempt failed on $label", error)
            }
        }

        throw IllegalStateException(
            "Could not initialize Gemma engine. Attempts: ${errors.joinToString(" | ")}",
        )
    }

    fun getEngine(): Engine {
        val current = engine
        check(current != null && current.isInitialized()) {
            "Gemma engine is not initialized"
        }
        return current
    }

    fun isInitialized(): Boolean = engine?.isInitialized() == true

    fun backendLabel(): String = activeBackend

    suspend fun release() = mutex.withLock {
        releaseLocked()
    }

    private fun releaseLocked() {
        try {
            engine?.close()
        } catch (error: Throwable) {
            Log.w(TAG, "Error closing Gemma engine", error)
        } finally {
            engine = null
            modelPath = null
            activeBackend = "none"
        }
    }

    companion object {
        private const val TAG = "GemmaModelManager"
    }
}
