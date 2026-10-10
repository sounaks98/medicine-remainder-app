/// Versioned OCR output (blocks/lines JSON in later phases).
class OcrResult {
  const OcrResult({
    required this.version,
    required this.fullText,
    this.blocksJson,
  });

  final int version;
  final String fullText;
  final String? blocksJson;
}
