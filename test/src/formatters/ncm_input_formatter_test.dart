import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return NCMInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('NCMInputFormatter', () {
    test('padrao', () => expect(evaluate('', '12345678'), '1234.56.78'));
    test('limite 8 digitos', () => expect(evaluate('', '912345678'), ''));
    test('backspace', () {
      expect(evaluate('', '1234567'), '1234.56.7');
      expect(evaluate('', '123456'), '1234.56');
      expect(evaluate('', '12345'), '1234.5');
      expect(evaluate('', '1234'), '1234');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '1'), '1');
    });

    test('digitacao', () {
      expect(evaluate('', '1'), '1');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '1234'), '1234');
      expect(evaluate('', '12345'), '1234.5');
      expect(evaluate('', '123456'), '1234.56');
      expect(evaluate('', '1234567'), '1234.56.7');
    });
  });
}
