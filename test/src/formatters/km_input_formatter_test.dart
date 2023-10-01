import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return KmInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('KmInputFormatter', () {
    test('padrao', () => expect(evaluate('', '123456'), '123.456'));
    test('testa limite 6 digitos', () => expect(evaluate('', '9123456'), ''));

    test('backspace', () {
      expect(evaluate('', '12345'), '12.345');
      expect(evaluate('', '1234'), '1.234');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '1'), '1');
    });

    test('digitacao', () {
      expect(evaluate('', '1'), '1');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '1234'), '1.234');
      expect(evaluate('', '12345'), '12.345');
      expect(evaluate('', '123456'), '123.456');
    });
  });
}
