/// BPE bridge aligned with bundled `tokenizer.json` (P3-03).
class TokenizerService {
  const TokenizerService();

  Future<List<int>> encode(String text) {
    throw UnimplementedError('P3-03');
  }

  String decode(List<int> tokenIds) {
    throw UnimplementedError('P3-03');
  }
}
