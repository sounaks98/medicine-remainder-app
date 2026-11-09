/// Strips markdown fences and isolates a JSON object for tests / Dart-side guard.
class GemmaResultParser {
  static final _fence =
      RegExp(r'```(?:json)?\s*([\s\S]*?)```', caseSensitive: false);

  static String stripCodeFences(String raw) {
    final trimmed = raw.trim();
    final match = _fence.firstMatch(trimmed);
    if (match != null) {
      return match.group(1)!.trim();
    }
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    return trimmed;
  }
}
