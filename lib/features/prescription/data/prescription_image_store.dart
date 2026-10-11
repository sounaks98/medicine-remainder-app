import 'dart:io';

import 'package:medicine_remainder_app/services/security/prescription_image_cipher.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// App-private prescription image paths and temp lifecycle (P1-01, P5-03).
class PrescriptionImageStore {
  const PrescriptionImageStore({
    Uuid? uuid,
    Directory? rootDirectory,
    PrescriptionImageCipher? cipher,
    this.encryptAtRest = true,
  })  : _uuid = uuid ?? const Uuid(),
        _rootDirectory = rootDirectory,
        _cipher = cipher;

  static const _relativeSegments = ['prescriptions', 'tmp'];

  final Uuid _uuid;
  final PrescriptionImageCipher? _cipher;
  final bool encryptAtRest;

  /// When set (tests), used instead of [getApplicationDocumentsDirectory].
  final Directory? _rootDirectory;

  Future<PrescriptionImageCipher> _resolveCipher() async {
    return _cipher ?? await PrescriptionImageCipher.loadOrCreate();
  }

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
    final extension = _extensionForMimeType(mimeType, encrypted: encryptAtRest);
    final fileName = '${_uuid.v4()}.$extension';
    final file = File(p.join(dir.path, fileName));
    final payload = encryptAtRest
        ? await _resolveCipher().then((c) => c.encryptBytes(bytes))
        : bytes;
    await file.writeAsBytes(payload, flush: true);
    return file.path;
  }

  /// Reads decrypted image bytes when encryption is enabled.
  Future<List<int>> readBytes(String path) async {
    final file = File(path);
    final raw = await file.readAsBytes();
    if (!encryptAtRest) {
      return raw;
    }
    final cipher = await _resolveCipher();
    if (cipher.looksEncrypted(raw)) {
      return cipher.decryptBytes(raw);
    }
    return raw;
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

  static String _extensionForMimeType(String mimeType, {required bool encrypted}) {
    if (encrypted) {
      return 'mrx';
    }
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
