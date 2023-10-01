import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return AlturaInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('AlturaInputFormatter', () {
    test('padrao', () => expect(evaluate('', '175'), '1,75'));
    test('limite 3 digitos', () => expect(evaluate('', '1759'), ''));
    test('valor > 3', () => expect(evaluate('', '3'), ''));
    test('backspace', () {
      expect(evaluate('1,75', '17'), '1,7');
      expect(evaluate('1,7', '1'), '1');
      expect(evaluate('1', ''), '');
      expect(evaluate('', ''), '');
    });
  });
}
