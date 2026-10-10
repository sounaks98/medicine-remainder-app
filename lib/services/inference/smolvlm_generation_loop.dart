/// Autoregressive decoder loop with KV cache (P3-05).
class SmolVlmGenerationLoop {
  const SmolVlmGenerationLoop();

  Future<String> generate({
    required Object visionInput,
    required String prompt,
    int maxNewTokens = 128,
  }) {
    throw UnimplementedError('P3-05');
  }

  Future<void> dispose() async {}
}
