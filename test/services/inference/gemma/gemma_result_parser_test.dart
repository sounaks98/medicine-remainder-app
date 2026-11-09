import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_remainder_app/services/inference/gemma/gemma_result_parser.dart';

void main() {
  test('strips markdown json fences', () {
    const raw = '```json\n{"medicines":[]}\n```';
    expect(GemmaResultParser.stripCodeFences(raw), '{"medicines":[]}');
  });

  test('extracts json object from prose', () {
    const raw = 'Here is output:\n{"medicines":[{"name":"A"}]}\nDone.';
    expect(
      GemmaResultParser.stripCodeFences(raw),
      '{"medicines":[{"name":"A"}]}',
    );
  });

  test('prefers fenced json over outer braces in prose', () {
    const raw = 'Note {"bad":true}\n```JSON\n{"medicines":[]}\n```';
    expect(GemmaResultParser.stripCodeFences(raw), '{"medicines":[]}');
  });

  test('returns trimmed raw when no json object present', () {
    expect(GemmaResultParser.stripCodeFences('  no json here  '), 'no json here');
  });
}
