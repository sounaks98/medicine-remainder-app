import 'dart:ffi';
import 'dart:io';

String? deviceAbiDescription() {
  if (Platform.isAndroid) {
    return Abi.current().toString();
  }
  return null;
}

/// `.litertlm` (Gemma spike) ships native libs for Android arm64 only.
bool get deviceSupportsLitertLm {
  if (!Platform.isAndroid) return true;
  return Abi.current() == Abi.androidArm64;
}
