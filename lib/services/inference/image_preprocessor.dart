/// Shared image preprocessing (OCR rotate/resize; Idefics3 tensors for VLM).
class ImagePreprocessor {
  const ImagePreprocessor();

  Future<List<int>> preprocessForOcr(String imagePath) {
    throw UnimplementedError('P1-02');
  }

  Future<Object?> preprocessForVlm(String imagePath) {
    throw UnimplementedError('P3-04');
  }
}
