package com.medicinereminder.medicine_remainder_app.gemma

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import androidx.exifinterface.media.ExifInterface
import java.io.File
import java.io.FileOutputStream
import kotlin.math.max
import kotlin.math.roundToInt

object GemmaImagePreprocessor {
    fun prepareForInference(sourcePath: String): File {
        val sourceFile = File(sourcePath)
        if (!sourceFile.isFile) {
            throw IllegalArgumentException("Image not found: $sourcePath")
        }

        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(sourcePath, bounds)

        val longest = max(bounds.outWidth, bounds.outHeight)
        val sampleSize =
            if (longest <= GemmaConstants.MAX_IMAGE_LONG_EDGE) {
                1
            } else {
                var size = 1
                var scaled = longest
                while (scaled / 2 > GemmaConstants.MAX_IMAGE_LONG_EDGE) {
                    size *= 2
                    scaled /= 2
                }
                size
            }

        val decodeOptions =
            BitmapFactory.Options().apply {
                inSampleSize = sampleSize
                inPreferredConfig = Bitmap.Config.ARGB_8888
            }
        var bitmap =
            BitmapFactory.decodeFile(sourcePath, decodeOptions)
                ?: throw IllegalArgumentException("Could not decode image")

        bitmap = applyExifOrientation(sourcePath, bitmap)

        val currentLongest = max(bitmap.width, bitmap.height)
        if (currentLongest > GemmaConstants.MAX_IMAGE_LONG_EDGE) {
            val scale = GemmaConstants.MAX_IMAGE_LONG_EDGE.toFloat() / currentLongest.toFloat()
            val targetW = (bitmap.width * scale).roundToInt().coerceAtLeast(1)
            val targetH = (bitmap.height * scale).roundToInt().coerceAtLeast(1)
            val scaled = Bitmap.createScaledBitmap(bitmap, targetW, targetH, true)
            if (scaled != bitmap) {
                bitmap.recycle()
            }
            bitmap = scaled
        }

        val outFile = File.createTempFile("gemma_rx_", ".jpg")
        FileOutputStream(outFile).use { stream ->
            bitmap.compress(Bitmap.CompressFormat.JPEG, 88, stream)
        }
        bitmap.recycle()
        return outFile
    }

    private fun applyExifOrientation(path: String, bitmap: Bitmap): Bitmap {
        val exif = ExifInterface(path)
        val orientation =
            exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_NORMAL,
            )
        val matrix =
            when (orientation) {
                ExifInterface.ORIENTATION_ROTATE_90 -> Matrix().apply { postRotate(90f) }
                ExifInterface.ORIENTATION_ROTATE_180 -> Matrix().apply { postRotate(180f) }
                ExifInterface.ORIENTATION_ROTATE_270 -> Matrix().apply { postRotate(270f) }
                else -> return bitmap
            }
        val rotated =
            Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        if (rotated != bitmap) {
            bitmap.recycle()
        }
        return rotated
    }
}
