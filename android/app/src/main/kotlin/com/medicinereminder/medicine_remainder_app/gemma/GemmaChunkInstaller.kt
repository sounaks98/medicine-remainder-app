package com.medicinereminder.medicine_remainder_app.gemma

import android.content.Context
import android.os.StatFs
import com.google.android.play.core.assetpacks.AssetPackManagerFactory
import java.io.File
import java.io.InputStream
import java.security.MessageDigest

class GemmaChunkInstaller(private val context: Context) {
    fun materializedModelFile(): File =
        File(context.filesDir, "gemma3n/${GemmaConstants.MODEL_FILE_NAME}")

    fun isModelMaterialized(metadata: GemmaChecksumMetadata): Boolean {
        val target = materializedModelFile()
        if (!target.isFile) return false
        if (target.length() != metadata.sizeBytes) return false
        val installedMark = File(context.filesDir, "gemma3n/.installed_sha256")
        if (!installedMark.isFile) return false
        return installedMark.readText().trim().equals(metadata.sha256, ignoreCase = true)
    }

    fun ensureModelInstalled(
        metadata: GemmaChecksumMetadata,
        onProgress: (Double) -> Unit,
    ): String {
        val existing = materializedModelFile()
        if (isModelMaterialized(metadata)) {
            onProgress(1.0)
            return existing.absolutePath
        }

        val neededBytes = metadata.sizeBytes + (64L * 1024 * 1024)
        val freeBytes = freeBytesOnDataPartition()
        if (freeBytes < neededBytes) {
            throw IllegalStateException(
                "Not enough storage to install Gemma model. " +
                    "Need ~${neededBytes / (1024 * 1024)} MB free, have ${freeBytes / (1024 * 1024)} MB.",
            )
        }

        val outDir = existing.parentFile ?: throw IllegalStateException("Invalid model path")
        outDir.mkdirs()
        val temp = File(outDir, "${existing.name}.partial")

        val digest = MessageDigest.getInstance("SHA-256")
        var written = 0L

        temp.outputStream().use { output ->
            metadata.chunkNames.forEachIndexed { index, chunkName ->
                openChunkStream(chunkName, index).use { input ->
                    val buffer = ByteArray(8 * 1024 * 1024)
                    var read = input.read(buffer)
                    while (read > 0) {
                        output.write(buffer, 0, read)
                        digest.update(buffer, 0, read)
                        written += read
                        onProgress(
                            (written.toDouble() / metadata.sizeBytes.toDouble()).coerceIn(0.0, 0.99),
                        )
                        read = input.read(buffer)
                    }
                }
            }
        }

        if (written != metadata.sizeBytes) {
            temp.delete()
            throw IllegalStateException(
                "Concatenated model size $written does not match expected ${metadata.sizeBytes}",
            )
        }
        val sha = digest.digest().joinToString("") { byte -> "%02x".format(byte) }
        if (!sha.equals(metadata.sha256, ignoreCase = true)) {
            temp.delete()
            throw IllegalStateException("Assembled model sha256 mismatch")
        }

        if (existing.isFile) {
            existing.delete()
        }
        if (!temp.renameTo(existing)) {
            temp.copyTo(existing, overwrite = true)
            temp.delete()
        }

        File(outDir, ".installed_sha256").writeText(metadata.sha256)
        onProgress(1.0)
        return existing.absolutePath
    }

    private fun openChunkStream(chunkName: String, chunkIndex: Int): InputStream {
        val assetPath = "${GemmaConstants.ASSET_DIR}/$chunkName"
        try {
            return context.assets.open(assetPath)
        } catch (_: Exception) {
            // fall through to asset pack
        }

        val packManager = AssetPackManagerFactory.getInstance(context)
        val packName =
            GemmaConstants.ASSET_PACK_NAMES.getOrNull(chunkIndex)
                ?: throw IllegalStateException("No asset pack for chunk index $chunkIndex")

        val location =
            packManager.getPackLocation(packName)
                ?: throw IllegalStateException("Asset pack $packName not available on device")

        val packAssetsDir = location.assetsPath()
        val chunkFile = File(packAssetsDir, chunkName)
        if (!chunkFile.isFile) {
            throw IllegalStateException("Chunk missing in pack $packName: ${chunkFile.absolutePath}")
        }
        return chunkFile.inputStream()
    }

    fun readChecksumFromAssets(): GemmaChecksumMetadata {
        val text =
            context.assets.open(GemmaConstants.CHECKSUM_ASSET).bufferedReader().use { it.readText() }
        return GemmaChecksum.parse(text)
    }

    private fun freeBytesOnDataPartition(): Long {
        val stat = StatFs(context.filesDir.absolutePath)
        return stat.availableBytes
    }
}
