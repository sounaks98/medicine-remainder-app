import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// App-private prescription image paths and temp lifecycle (P1-01).
class PrescriptionImageStore {
  const PrescriptionImageStore({
    Uuid? uuid,
    this._rootDirectory,
  }) : _uuid = uuid ?? const Uuid();

  static const _relativeSegments = ['prescriptions', 'tmp'];

  final Uuid _uuid;

  /// When set (tests), used instead of [getApplicationDocumentsDirectory].
  final Directory? _rootDirectory;

  Future<Directory> _temporaryDirectory() async {
    final documents = _rootDirectory ?? await getApplicationDocumentsDirectory();
    final dir = Directory(p.joinAll([documents.path, ..._relativeSegments]));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Persists [bytes] under app documents only; returns the absolute file path.
  Future<String> saveTemporary(List<int> bytes, {required String mimeType}) async {
    final dir = await _temporaryDirectory();
    final extension = _extensionForMimeType(mimeType);
    final fileName = '${_uuid.v4()}.$extension';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  /// Deletes a file previously returned by [saveTemporary].
  Future<void> delete(String path) async {
    final dir = await _temporaryDirectory();
    final absolutePath = p.normalize(p.absolute(path));
    final rootPath = p.normalize(p.absolute(dir.path));
    if (!p.isWithin(rootPath, absolutePath)) {
      throw ArgumentError.value(path, 'path', 'Not under prescription image store');
    }
    final file = File(absolutePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static String _extensionForMimeType(String mimeType) {
    switch (mimeType.toLowerCase()) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/heic':
      case 'image/heif':
        return 'heic';
      case 'image/jpeg':
      case 'image/jpg':
      default:
        return 'jpg';
    }
  }
}
