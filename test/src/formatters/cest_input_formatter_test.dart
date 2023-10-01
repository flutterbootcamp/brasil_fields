import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CESTInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CESTInputFormatter', () {
    test('padrao', () => expect(evaluate('', '1234567'), '12.345.67'));
    test('limite 7 digitos', () => expect(evaluate('', '12345678'), ''));

    test('backspace', () {
      expect(evaluate('12.345.67', '123456'), '12.345.6');
      expect(evaluate('12.345.6', '12345'), '12.345');
      expect(evaluate('12.345', '1234'), '12.34');
      expect(evaluate('12.34', '123'), '12.3');
      expect(evaluate('12.3', '12'), '12');
      expect(evaluate('12', '1'), '1');
      expect(evaluate('1', ''), '');
    });
  });
}
