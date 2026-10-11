import 'package:medicine_remainder_app/shared/config/huggingface_token_env_io.dart'
    if (dart.library.html) 'package:medicine_remainder_app/shared/config/huggingface_token_env_stub.dart';

/// Hugging Face token for gated model downloads (e.g. Gemma).
///
/// Resolution order: [override], `HUGGINGFACE_TOKEN` process environment,
/// then `--dart-define=HUGGINGFACE_TOKEN=...`.
String? resolveHuggingFaceToken([String? override]) {
  if (override != null && override.isNotEmpty) return override;

  final fromProcessEnv = huggingFaceTokenFromProcessEnvironment();
  if (fromProcessEnv != null) return fromProcessEnv;

  const fromDefine = String.fromEnvironment('HUGGINGFACE_TOKEN');
  if (fromDefine.isNotEmpty) return fromDefine;

  return null;
}
