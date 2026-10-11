import 'dart:io';

String? huggingFaceTokenFromProcessEnvironment() {
  final value = Platform.environment['HUGGINGFACE_TOKEN'];
  if (value == null || value.isEmpty) return null;
  return value;
}
