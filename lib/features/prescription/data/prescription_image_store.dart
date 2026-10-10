/// App-private prescription image paths and temp lifecycle (P1-01).
class PrescriptionImageStore {
  const PrescriptionImageStore();

  Future<String> saveTemporary(List<int> bytes, {required String mimeType}) {
    throw UnimplementedError('P1-01');
  }

  Future<void> delete(String path) {
    throw UnimplementedError('P1-01');
  }
}
