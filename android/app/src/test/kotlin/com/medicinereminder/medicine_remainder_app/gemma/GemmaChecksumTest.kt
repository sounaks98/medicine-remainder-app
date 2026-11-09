package com.medicinereminder.medicine_remainder_app.gemma

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class GemmaChecksumTest {
    @Test
    fun parse_readsChunkMetadata() {
        val text =
            """
            artifact=gemma-3n-E2B-it-int4.litertlm
            sha256=deadbeef
            size_bytes=100
            chunk_count=2
            chunk_0=gemma.part0
            chunk_0_sha256=aaa
            chunk_1=gemma.part1
            chunk_1_sha256=bbb
            """.trimIndent()
        val meta = GemmaChecksum.parse(text)
        assertEquals("deadbeef", meta.sha256)
        assertEquals(100L, meta.sizeBytes)
        assertEquals(listOf("gemma.part0", "gemma.part1"), meta.chunkNames)
        assertEquals(listOf("aaa", "bbb"), meta.chunkExpectedSha)
    }

    @Test
    fun parse_failsWhenSha256Missing() {
        val text =
            """
            size_bytes=100
            chunk_count=1
            """.trimIndent()
        assertThrows(IllegalArgumentException::class.java) {
            GemmaChecksum.parse(text)
        }
    }
}
