package com.medicinereminder.medicine_remainder_app.gemma

import org.json.JSONArray
import org.json.JSONObject

object GemmaResultHandler {
    private val fencePattern =
        Regex("```(?:json)?\\s*([\\s\\S]*?)```", RegexOption.IGNORE_CASE)

    fun stripCodeFences(raw: String): String {
        val match = fencePattern.find(raw.trim())
        if (match != null) {
            return match.groupValues[1].trim()
        }
        val trimmed = raw.trim()
        val start = trimmed.indexOf('{')
        val end = trimmed.lastIndexOf('}')
        if (start >= 0 && end > start) {
            return trimmed.substring(start, end + 1)
        }
        return trimmed
    }

    fun parsePrescriptionJson(raw: String): JSONObject {
        val jsonText = stripCodeFences(raw)
        return JSONObject(jsonText)
    }

    fun toResultMap(root: JSONObject): Map<String, Any?> {
        val medicines = JSONArray()
        if (root.has("medicines")) {
            val source = root.optJSONArray("medicines") ?: JSONArray()
            for (i in 0 until source.length()) {
                val item = source.optJSONObject(i) ?: continue
                val cleaned = JSONObject()
                listOf(
                    "name",
                    "strength",
                    "dose",
                    "frequency",
                    "duration",
                    "route",
                    "instructions",
                    "confidence",
                    "needs_verification",
                ).forEach { key ->
                    if (item.has(key) && !item.isNull(key)) {
                        cleaned.put(key, item.get(key))
                    }
                }
                if (cleaned.length() > 0) {
                    medicines.put(cleaned)
                }
            }
        }

        val result = linkedMapOf<String, Any?>(
            "medicines" to jsonArrayToList(medicines),
        )

        listOf(
            "patient_name",
            "prescriber",
            "prescription_date",
            "notes",
        ).forEach { key ->
            if (root.has(key) && !root.isNull(key)) {
                result[key] = root.get(key)
            }
        }
        return result
    }

    private fun jsonArrayToList(array: JSONArray): List<Map<String, Any?>> {
        val out = mutableListOf<Map<String, Any?>>()
        for (i in 0 until array.length()) {
            val obj = array.optJSONObject(i) ?: continue
            val map = linkedMapOf<String, Any?>()
            obj.keys().forEach { key ->
                map[key] = obj.get(key)
            }
            out += map
        }
        return out
    }
}
