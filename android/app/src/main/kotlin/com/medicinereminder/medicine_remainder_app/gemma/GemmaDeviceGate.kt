package com.medicinereminder.medicine_remainder_app.gemma

import android.app.ActivityManager
import android.content.Context
import android.os.Build

object GemmaDeviceGate {
    fun compatibilityError(context: Context): String? {
        if (!supportsArm64()) {
            return "Gemma on-device inference requires a 64-bit ARM Android device (arm64-v8a)."
        }
        val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val info = ActivityManager.MemoryInfo()
        am.getMemoryInfo(info)
        if (info.availMem < GemmaConstants.MIN_AVAILABLE_RAM_BYTES) {
            return "Not enough available RAM to load Gemma (~2.5 GB free required)."
        }
        return null
    }

    fun supportsArm64(): Boolean {
        val abis = Build.SUPPORTED_ABIS?.toList() ?: emptyList()
        return abis.any { it.equals("arm64-v8a", ignoreCase = true) }
    }
}
