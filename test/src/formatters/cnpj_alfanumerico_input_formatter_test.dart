import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters =
      alphaNumericFormatterChain(CnpjAlfanumericoInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CnpjInputAlfanumericoFormatter', () {
    test(
      'padrao alfanumérico',
      () => expect(
          evaluate(textEditingValue(''), textEditingValue('AAAAAAAAAAAA99'))
              .text,
          'AA.AAA.AAA/AAAA-99'),
    );

    test(
      'limite 14 digitos alfanuméricos',
      () {
        final oldValue = textEditingValue('AA.AAA.AAA/AAAA-99');
        expect(
          evaluate(oldValue, textEditingValue('AA.AAA.AAA/AAAA-999')),
          oldValue,
        );
      },
    );

    test('backspace alfanumérico', () {
      var state = textEditingValue('AA.BBB.CCC/DDDD-99');
      final cases = {
        'AABBBCCCDDDD9': 'AA.BBB.CCC/DDDD-9',
        'AABBBCCCDDDD': 'AA.BBB.CCC/DDDD',
        'AABBBCCCDDD': 'AA.BBB.CCC/DDD',
        'AABBBCCCDD': 'AA.BBB.CCC/DD',
        'AABBBCCCD': 'AA.BBB.CCC/D',
        'AABBBCCC': 'AA.BBB.CCC',
        'AABBBCC': 'AA.BBB.CC',
        'AABBBC': 'AA.BBB.C',
        'AABBB': 'AA.BBB',
        'AABB': 'AA.BB',
        'AAB': 'AA.B',
        'AA': 'AA',
        'A': 'A',
        '': '',
      };
      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('AAB', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('AA'), value);
    });
  });
}
