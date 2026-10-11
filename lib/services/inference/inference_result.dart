/// Result of an on-device multimodal inference attempt (Gemma spike / future VLM).
class InferenceResult {
  const InferenceResult({
    this.text,
    this.loadDuration,
    this.inferenceDuration,
    this.errorKind,
    this.errorMessage,
    this.tokensApprox,
  });

  final String? text;
  final Duration? loadDuration;
  final Duration? inferenceDuration;
  final InferenceErrorKind? errorKind;

  /// User-safe, non-PHI error summary.
  final String? errorMessage;
  final int? tokensApprox;

  bool get isSuccess => errorKind == null && text != null;
}

enum InferenceErrorKind {
  unavailable,
  notLoaded,
  modelFile,
  insufficientMemory,
  imageDecode,
  inference,
  cancelled,
  malformedOutput,
  disposed,
}
