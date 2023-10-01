import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return TemperaturaInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('description', () {
    test('padrao', () => expect(evaluate('', '246'), '24,6'));
    test('limite 3 digitos', () => expect(evaluate('', '9246'), ''));
    test('backspace', () {
      expect(evaluate('', '24'), '2,4');
      expect(evaluate('', '2'), '2');
      expect(evaluate('', ''), '');
    });

    test('digitacao', () {
      expect(evaluate('', '2'), '2');
      expect(evaluate('', '24'), '2,4');
      expect(evaluate('', '246'), '24,6');
    });
  });
}
