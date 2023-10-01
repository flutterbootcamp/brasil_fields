import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return IOFInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('IOFInputFormatter', () {
    test('padrao', () => expect(evaluate('', '1234567'), '1,234567'));
    test('limite 7 digitos', () => expect(evaluate('', '12345678'), ''));
    test('backspace', () {
      expect(evaluate('1,234567', '123456'), '1,23456');
      expect(evaluate('1,23456', '12345'), '1,2345');
      expect(evaluate('1,2345', '1234'), '1,234');
      expect(evaluate('1,234', '123'), '1,23');
      expect(evaluate('1,23', '12'), '1,2');
      expect(evaluate('1,2', '1'), '1');
      expect(evaluate('1', ''), '');
    });
  });
}
