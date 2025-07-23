import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CnpjAlfanumericoInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CnpjInputAlfanumericoFormatter', () {
    test(
      'padrao alfanumérico',
      () => expect(evaluate('', 'AAAAAAAAAAAA99'), 'AA.AAA.AAA/AAAA-99'),
    );

    test(
      'limite 14 digitos alfanuméricos',
      () => expect(evaluate('', 'ABBBBBBBBBBBB99'), 'AB.BBB.BBB/BBBB-99'),
    );

    test('backspace alfanumérico', () {
      expect(
        evaluate('AA.BBB.CCC/DDDD-99', 'AABBBCCCDDDD9'),
        'AA.BBB.CCC/DDDD-9',
      );
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
