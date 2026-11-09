package com.medicinereminder.medicine_remainder_app.gemma

object GemmaConstants {
    const val CHANNEL = "com.prescriptionreader/gemma"
    const val EVENT_CHANNEL = "com.prescriptionreader/gemma_events"

    const val MODEL_FILE_NAME = "gemma-3n-E2B-it-int4.litertlm"
    const val ASSET_DIR = "gemma"
    const val CHECKSUM_ASSET = "gemma/CHECKSUM.txt"
    const val CHUNK_PREFIX = "gemma.part"

    const val MAX_NUM_TOKENS = 4096
    const val MAX_IMAGE_LONG_EDGE = 768
    // Gate before loading ~3.7 GB weights (6 GB phones often report <2.5 GiB free).
    const val MIN_AVAILABLE_RAM_BYTES = 1_610_612_736L // 1.5 GiB available

    val ASSET_PACK_NAMES =
        listOf(
            "gemma_pack0",
            "gemma_pack1",
            "gemma_pack2",
        )
}
