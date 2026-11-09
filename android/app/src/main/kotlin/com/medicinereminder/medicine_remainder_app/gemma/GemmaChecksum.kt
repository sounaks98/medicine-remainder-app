package com.medicinereminder.medicine_remainder_app.gemma

data class GemmaChecksumMetadata(
    val artifactName: String,
    val sha256: String,
    val sizeBytes: Long,
    val chunkCount: Int,
    val chunkNames: List<String>,
    val chunkExpectedSha: List<String?>,
)

object GemmaChecksum {
    fun parse(text: String): GemmaChecksumMetadata {
        val props = linkedMapOf<String, String>()
        text.lineSequence().forEach { line ->
            val trimmed = line.trim()
            if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEach
            val idx = trimmed.indexOf('=')
            if (idx <= 0) return@forEach
            props[trimmed.substring(0, idx).trim()] = trimmed.substring(idx + 1).trim()
        }

        val chunkCount = props["chunk_count"]?.toIntOrNull() ?: 3
        val names = mutableListOf<String>()
        val shas = mutableListOf<String?>()
        repeat(chunkCount) { index ->
            names += props["chunk_$index"] ?: "${GemmaConstants.CHUNK_PREFIX}$index"
            shas += props["chunk_${index}_sha256"]
        }

        return GemmaChecksumMetadata(
            artifactName = props["artifact"] ?: GemmaConstants.MODEL_FILE_NAME,
            sha256 = props["sha256"]
                ?: throw IllegalArgumentException("CHECKSUM.txt missing sha256"),
            sizeBytes = props["size_bytes"]?.toLongOrNull()
                ?: throw IllegalArgumentException("CHECKSUM.txt missing size_bytes"),
            chunkCount = chunkCount,
            chunkNames = names,
            chunkExpectedSha = shas,
        )
    }
}
