import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AES encryption for prescription images at rest (P5-03).
class PrescriptionImageCipher {
  PrescriptionImageCipher(this._key);

  static const String fileMagic = 'MRX1';
  static const _storageKey = 'prescription_image_aes_key_v1';

  final encrypt.Key _key;

  static Future<PrescriptionImageCipher> loadOrCreate({
    FlutterSecureStorage? storage,
    List<int>? testKeyBytes,
  }) async {
    if (testKeyBytes != null) {
      return PrescriptionImageCipher(encrypt.Key(Uint8List.fromList(testKeyBytes)));
    }
    final secureStorage = storage ?? const FlutterSecureStorage();
    final existing = await secureStorage.read(key: _storageKey);
    if (existing != null) {
      final decoded = base64Decode(existing);
      return PrescriptionImageCipher(encrypt.Key(decoded));
    }
    final key = encrypt.Key.fromSecureRandom(32);
    await secureStorage.write(key: _storageKey, value: base64Encode(key.bytes));
    return PrescriptionImageCipher(key);
  }

  Uint8List encryptBytes(List<int> plain) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encryptBytes(plain, iv: iv);
    final builder = BytesBuilder();
    builder.add(utf8.encode(fileMagic));
    builder.add(iv.bytes);
    builder.add(encrypted.bytes);
    return builder.takeBytes();
  }

  List<int> decryptBytes(List<int> payload) {
    final magicLength = utf8.encode(fileMagic).length;
    if (payload.length < magicLength + 16) {
      throw FormatException('Encrypted payload too short');
    }
    final magic = utf8.decode(payload.sublist(0, magicLength));
    if (magic != fileMagic) {
      throw FormatException('Not an encrypted prescription image');
    }
    final iv = encrypt.IV(Uint8List.fromList(payload.sublist(magicLength, magicLength + 16)));
    final cipherBytes = payload.sublist(magicLength + 16);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.decryptBytes(encrypt.Encrypted(Uint8List.fromList(cipherBytes)), iv: iv);
  }

  bool looksEncrypted(List<int> bytes) {
    if (bytes.length < fileMagic.length) {
      return false;
    }
    return utf8.decode(bytes.sublist(0, fileMagic.length)) == fileMagic;
  }
}
