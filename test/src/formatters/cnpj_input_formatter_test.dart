import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CnpjInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CnpjInputFormatter', () {
    test(
      'padrao',
      () => expect(evaluate('', '99999999999999'), '99.999.999/9999-99'),
    );

    test(
      'padrao alfanumérico',
      () => expect(evaluate('', 'AAAAAAAAAAAA99'), 'AA.AAA.AAA/AAAA-99'),
    );

    test(
      'limite 14 digitos',
      () => expect(evaluate('', '199999999999999'), ''),
    );

    test(
      'limite 14 digitos alfanumérico',
      () => expect(evaluate('', 'ABBBBBBBBBBBB99'), ''),
    );

    test('backspace', () {
      expect(
          evaluate('99.999.999/9999-99', '9999999999999'), '99.999.999/9999-9');
      expect(evaluate('99.999.999/9999-9', '999999999999'), '99.999.999/9999');
      expect(evaluate('99.999.999/9999', '99999999999'), '99.999.999/999');
      expect(evaluate('99.999.999/999', '9999999999'), '99.999.999/99');
      expect(evaluate('99.999.999/99', '999999999'), '99.999.999/9');
      expect(evaluate('99.999.999/9', '99999999'), '99.999.999');
      expect(evaluate('99.999.999', '9999999'), '99.999.99');
      expect(evaluate('99.999.99', '999999'), '99.999.9');
      expect(evaluate('99.999.9', '99999'), '99.999');
      expect(evaluate('99.999', '9999'), '99.99');
      expect(evaluate('99.99', '999'), '99.9');
      expect(evaluate('99.9', '99'), '99');
      expect(evaluate('99', '9'), '9');
      expect(evaluate('9', ''), '');
    });

    test('backspace alfanumérico', () {
      expect(
          evaluate('AA.BBB.CCC/DDDD-99', 'AABBBCCCDDDD9'), 'AA.BBB.CCC/DDDD-9');
      expect(evaluate('AA.BBB.CCC/DDDD-9', 'AABBBCCCDDDD'), 'AA.BBB.CCC/DDDD');
      expect(evaluate('AA.BBB.CCC/DDDD', 'AABBBCCCDDD'), 'AA.BBB.CCC/DDD');
      expect(evaluate('AA.BBB.CCC/DDD', 'AABBBCCCDD'), 'AA.BBB.CCC/DD');
      expect(evaluate('AA.BBB.CCC/DD', 'AABBBCCCD'), 'AA.BBB.CCC/D');
      expect(evaluate('AA.BBB.CCC/D', 'AABBBCCC'), 'AA.BBB.CCC');
      expect(evaluate('AA.BBB.CCC', 'AABBBCC'), 'AA.BBB.CC');
      expect(evaluate('AA.BBB.CC', 'AABBBC'), 'AA.BBB.C');
      expect(evaluate('AA.BBB.C', 'AABBB'), 'AA.BBB');
      expect(evaluate('AA.BBB', 'AABB'), 'AA.BB');
      expect(evaluate('AA.BB', 'AAB'), 'AA.B');
      expect(evaluate('AA.B', 'AA'), 'AA');
      expect(evaluate('AA', 'A'), 'A');
      expect(evaluate('A', ''), '');
    });
  });
}
