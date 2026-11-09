package com.medicinereminder.medicine_remainder_app.gemma

import org.json.JSONException
import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class GemmaResultHandlerTest {
    @Test
    fun stripCodeFences_removesMarkdownJsonBlock() {
        val out = GemmaResultHandler.stripCodeFences("```json\n{\"medicines\":[]}\n```")
        assertEquals("{\"medicines\":[]}", out)
    }

    @Test
    fun parsePrescriptionJson_rejectsMalformedJson() {
        assertThrows(JSONException::class.java) {
            GemmaResultHandler.parsePrescriptionJson("{not-json")
        }
    }

    @Test
    fun toResultMap_keepsOnlyKnownMedicineKeys() {
        val root =
            GemmaResultHandler.parsePrescriptionJson(
                """
                {
                  "medicines": [
                    {
                      "name": "Med A",
                      "unknown_field": "drop-me",
                      "confidence": "high",
                      "needs_verification": false
                    }
                  ],
                  "patient_name": "Pat",
                  "extra_root": "ignore"
                }
                """.trimIndent(),
            )
        val map = GemmaResultHandler.toResultMap(root)
        @Suppress("UNCHECKED_CAST")
        val medicines = map["medicines"] as List<Map<String, Any?>>
        assertEquals(1, medicines.size)
        assertEquals("Med A", medicines[0]["name"])
        assertEquals(false, medicines[0].containsKey("unknown_field"))
        assertEquals("Pat", map["patient_name"])
        assertEquals(false, map.containsKey("extra_root"))
    }

    @Test
    fun toResultMap_doesNotSynthesizeMedicinesWhenArrayMissing() {
        val root = GemmaResultHandler.parsePrescriptionJson("{\"notes\":\"only\"}")
        val map = GemmaResultHandler.toResultMap(root)
        @Suppress("UNCHECKED_CAST")
        val medicines = map["medicines"] as List<Map<String, Any?>>
        assertEquals(0, medicines.size)
    }
}
