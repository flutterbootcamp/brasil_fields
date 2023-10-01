import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue, [int maxLength = 6]) {
    return ValidadeCartaoInputFormatter(maxLength: maxLength)
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('ValidadeCartaoInputFormatter', () {
    test('padrao', () => expect(evaluate('', '0928'), '09/28'));
    test('padrao [maxLength: 6]',
        () => expect(evaluate('', '092028', 6), '09/2028'));

    test('maxLength invalido', () {
      expect(() => evaluate('', '', 7), throwsAssertionError);
    });

    test('backspace', () {
      expect(evaluate('', '092'), '09/2');
      expect(evaluate('', '09'), '09');
      expect(evaluate('', '0'), '0');
      expect(evaluate('', ''), '');
    });

    test('backspace [maxLength: 6]', () {
      expect(evaluate('', '09202', 6), '09/202');
      expect(evaluate('', '0920', 6), '09/20');
      expect(evaluate('', '092', 6), '09/2');
      expect(evaluate('', '09', 6), '09');
      expect(evaluate('', '0', 6), '0');
      expect(evaluate('', '', 6), '');
    });

    test('digitacao', () {
      expect(evaluate('', '0'), '0');
      expect(evaluate('', '09'), '09');
      expect(evaluate('', '092'), '09/2');
      expect(evaluate('', '0929'), '09/29');
    });

    test('digitacao [maxLength: 6]', () {
      expect(evaluate('', '0', 6), '0');
      expect(evaluate('', '09', 6), '09');
      expect(evaluate('', '092', 6), '09/2');
      expect(evaluate('', '0920', 6), '09/20');
      expect(evaluate('', '09202', 6), '09/202');
      expect(evaluate('', '092029', 6), '09/2029');
    });
  });
}
