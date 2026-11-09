import java.security.MessageDigest

val gemmaModelsDir = rootProject.file("../models/gemma3n")
val gemmaAppAssetsDir = project.file("src/main/assets/gemma")
val gemmaAssetPackDirs =
    listOf(
        rootProject.file("gemma_pack0/src/main/assets"),
        rootProject.file("gemma_pack1/src/main/assets"),
        rootProject.file("gemma_pack2/src/main/assets"),
    )

fun sha256Hex(file: File): String {
  val digest = MessageDigest.getInstance("SHA-256")
  file.inputStream().use { input ->
    val buffer = ByteArray(8 * 1024 * 1024)
    var read = input.read(buffer)
    while (read > 0) {
      digest.update(buffer, 0, read)
      read = input.read(buffer)
    }
  }
  return digest.digest().joinToString("") { byte -> "%02x".format(byte) }
}

fun parseChecksumProperties(file: File): Map<String, String> {
  if (!file.isFile) return emptyMap()
  val out = linkedMapOf<String, String>()
  file.readLines().forEach { line ->
    val trimmed = line.trim()
    if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEach
    val idx = trimmed.indexOf('=')
    if (idx <= 0) return@forEach
    out[trimmed.substring(0, idx).trim()] = trimmed.substring(idx + 1).trim()
  }
  return out
}

fun copyChunkTo(chunk: File, destDir: File, destName: String) {
  destDir.mkdirs()
  val dest = File(destDir, destName)
  if (dest.isFile && dest.length() == chunk.length()) {
    return
  }
  chunk.copyTo(dest, overwrite = true)
}

fun buildingReleaseVariant(): Boolean {
  return gradle.startParameter.taskNames.any { name ->
    name.contains("Release", ignoreCase = true) ||
      name.contains("bundle", ignoreCase = true)
  }
}

fun buildingBundle(): Boolean {
  return gradle.startParameter.taskNames.any { name ->
    name.contains("bundle", ignoreCase = true)
  }
}

fun enableGemmaAssetPacks(): Boolean {
  return buildingBundle() ||
    (project.findProperty("enableGemmaAssetPacks") as String?) == "true"
}

fun readLocalPropertiesValue(key: String): String? {
  val file = rootProject.file("local.properties")
  if (!file.isFile) {
    return null
  }
  val props = java.util.Properties()
  file.inputStream().use { props.load(it) }
  return props.getProperty(key)?.trim()
}

fun packageGemmaInDebugRequested(): Boolean {
  if ((project.findProperty("packageGemmaInDebug") as String?) == "true") {
    return true
  }
  return readLocalPropertiesValue("packageGemmaInDebug").equals("true", ignoreCase = true)
}

fun clearGemmaPackagedOutputs() {
  if (gemmaAppAssetsDir.isDirectory) {
    gemmaAppAssetsDir.listFiles()?.forEach { child -> child.deleteRecursively() }
  }
  gemmaAssetPackDirs.forEach { dir ->
    if (dir.isDirectory) {
      dir.listFiles()?.forEach { child -> child.deleteRecursively() }
    }
  }
}

fun embedGemmaInThisBuild(): Boolean {
  if (packageGemmaInDebugRequested()) {
    return true
  }
  val names = gradle.startParameter.taskNames
  if (names.isEmpty()) {
    return false
  }
  if (names.any { it.contains("bundle", ignoreCase = true) }) {
    return true
  }
  return names.any { it.contains("Release", ignoreCase = true) }
}

fun purgeGemmaFromGradleCaches() {
  val roots =
    listOf(
      layout.buildDirectory.get().asFile,
      rootProject.file("../build/app"),
    )
  for (root in roots) {
    if (!root.isDirectory) {
      continue
    }
    root.walkTopDown().forEach { file ->
      if (!file.isFile) {
        return@forEach
      }
      val parentName = file.parentFile?.name
      if (file.name.startsWith("gemma.part") ||
        (file.name == "CHECKSUM.txt" && parentName == "gemma")
      ) {
        file.delete()
      }
    }
  }

  listOf(
    "intermediates/assets/debug",
    "intermediates/compressed_assets/debug",
  ).forEach { relative ->
    val dir = layout.buildDirectory.dir(relative).get().asFile
    if (dir.isDirectory) {
      dir.deleteRecursively()
    }
  }

  val staleApks =
    listOf(
      rootProject.file("../build/app/outputs/flutter-apk/app-debug.apk"),
      rootProject.file("../build/app/outputs/apk/debug/app-debug.apk"),
    )
  for (apk in staleApks) {
    if (!apk.isFile) {
      continue
    }
    val sizeMiB = apk.length() / (1024 * 1024)
    if (apk.length() > 500L * 1024L * 1024L) {
      apk.delete()
      logger.lifecycle(
        "Deleted stale oversize debug APK (${sizeMiB} MiB): " +
          apk.relativeTo(rootProject.file("..")),
      )
    }
  }
}

tasks.register("prepareGemmaModelChunks") {
  group = "build"
  description = "Copy verified Gemma LiteRT-LM chunks into APK assets and AAB install-time packs."

  doLast {
    val checksumFile = File(gemmaModelsDir, "CHECKSUM.txt")
    val embedGemma = embedGemmaInThisBuild()
    val releaseRequested = buildingReleaseVariant()

    if (!embedGemma) {
      clearGemmaPackagedOutputs()
      purgeGemmaFromGradleCaches()
      logger.lifecycle(
        "Debug build: omitting ~3.7 GB Gemma chunks from the APK. " +
          "Use release/bundle (or -PpackageGemmaInDebug=true) to package weights.",
      )
      return@doLast
    }

    if (!checksumFile.isFile) {
      if (releaseRequested) {
        throw GradleException(
          "Release build requires ${checksumFile.relativeTo(rootProject.projectDir)}. " +
            "Run: python scripts/download_gemma_model.py",
        )
      }
      logger.lifecycle(
        "Gemma CHECKSUM.txt missing — debug build continues without packaged weights.",
      )
      return@doLast
    }

    val meta = parseChecksumProperties(checksumFile)
    val chunkCount = meta["chunk_count"]?.toIntOrNull() ?: 3
    val expectedArtifactSha = meta["sha256"]
      ?: throw GradleException("CHECKSUM.txt missing sha256= line")
    val expectedSize = meta["size_bytes"]?.toLongOrNull()
      ?: throw GradleException("CHECKSUM.txt missing size_bytes= line")

    val chunkFiles = mutableListOf<File>()
    for (index in 0 until chunkCount) {
      val chunkName = meta["chunk_$index"] ?: "gemma.part$index"
      val expectedChunkSha = meta["chunk_${index}_sha256"]
      val source = File(gemmaModelsDir, chunkName)
      if (!source.isFile) {
        if (releaseRequested) {
          throw GradleException(
            "Missing $chunkName for Gemma packaging at ${source.absolutePath}",
          )
        }
        logger.warn("Gemma chunk $chunkName missing; skipping packaging.")
        return@doLast
      }
      if (expectedChunkSha != null) {
        val actual = sha256Hex(source)
        if (!actual.equals(expectedChunkSha, ignoreCase = true)) {
          throw GradleException(
            "Chunk $chunkName sha256 mismatch. Expected $expectedChunkSha, got $actual",
          )
        }
      }
      chunkFiles += source
    }

    val artifact = File(gemmaModelsDir, meta["artifact"] ?: "gemma-3n-E2B-it-int4.litertlm")
    if (artifact.isFile) {
      val artifactSha = sha256Hex(artifact)
      if (!artifactSha.equals(expectedArtifactSha, ignoreCase = true)) {
        throw GradleException(
          "On-disk artifact sha256 does not match CHECKSUM.txt for release packaging.",
        )
      }
      val size = artifact.length()
      if (expectedSize != size) {
        throw GradleException(
          "Artifact size mismatch: CHECKSUM expects $expectedSize bytes, file is $size bytes.",
        )
      }
    } else if (releaseRequested) {
      logger.lifecycle(
        "Full .litertlm artifact not present locally; chunk checksums were validated.",
      )
    }

    gemmaAppAssetsDir.mkdirs()
    checksumFile.copyTo(File(gemmaAppAssetsDir, "CHECKSUM.txt"), overwrite = true)

    if (buildingBundle()) {
      chunkFiles.forEachIndexed { index, chunk ->
        if (index < gemmaAssetPackDirs.size) {
          copyChunkTo(chunk, gemmaAssetPackDirs[index], chunk.name)
        }
      }
      logger.lifecycle(
        "Packaged ${chunkFiles.size} Gemma chunks into Play asset packs " +
          "(${expectedSize} bytes, sha256 verified).",
      )
    } else {
      gemmaAssetPackDirs.forEach { dir ->
        if (dir.isDirectory) {
          dir.listFiles()?.forEach { child -> child.deleteRecursively() }
        }
      }
      chunkFiles.forEach { chunk ->
        copyChunkTo(chunk, gemmaAppAssetsDir, chunk.name)
      }
      logger.lifecycle(
        "Packaged ${chunkFiles.size} Gemma chunks into APK assets " +
          "(${expectedSize} bytes, sha256 verified).",
      )
    }
  }
}

afterEvaluate {
  tasks.named("preBuild").configure {
    dependsOn("prepareGemmaModelChunks")
  }
  tasks.matching { it.name == "mergeDebugAssets" }.configureEach {
    dependsOn("prepareGemmaModelChunks")
    doFirst {
      if (!embedGemmaInThisBuild()) {
        purgeGemmaFromGradleCaches()
      }
    }
  }
}
