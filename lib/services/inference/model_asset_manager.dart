/// On-demand model download, checksum verify, and revision pin (P3-02).
class ModelAssetManager {
  const ModelAssetManager();

  Future<bool> isModelReady() {
    throw UnimplementedError('P3-02');
  }

  Future<void> downloadIfNeeded({void Function(double progress)? onProgress}) {
    throw UnimplementedError('P3-02');
  }
}
