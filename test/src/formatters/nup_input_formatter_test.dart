import 'package:brasil_fields/src/formatters/nup_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return NUPInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('NUPInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate('', '12345678901234567890'), '1234567-89.0123.4.56.7890'));
    test('limite 20 digitos',
        () => expect(evaluate('', '123456789012345678901'), ''));
    test('backspace', () {
      expect(evaluate('', '12345678901234567890'), '1234567-89.0123.4.56.7890');
      expect(evaluate('', '1234567890123456789'), '1234567-89.0123.4.56.789');
      expect(evaluate('', '123456789012345678'), '1234567-89.0123.4.56.78');
      expect(evaluate('', '12345678901234567'), '1234567-89.0123.4.56.7');
      expect(evaluate('', '1234567890123456'), '1234567-89.0123.4.56');
      expect(evaluate('', '123456789012345'), '1234567-89.0123.4.5');
      expect(evaluate('', '12345678901234'), '1234567-89.0123.4');
      expect(evaluate('', '1234567890123'), '1234567-89.0123');
      expect(evaluate('', '123456789012'), '1234567-89.012');
      expect(evaluate('', '12345678901'), '1234567-89.01');
      expect(evaluate('', '1234567890'), '1234567-89.0');
      expect(evaluate('', '123456789'), '1234567-89');
      expect(evaluate('', '12345678'), '1234567-8');
      expect(evaluate('', '1234567'), '1234567');
      expect(evaluate('', '123456'), '123456');
      expect(evaluate('', '12345'), '12345');
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
      expect(evaluate('', '12345'), '12345');
      expect(evaluate('', '123456'), '123456');
      expect(evaluate('', '1234567'), '1234567');
      expect(evaluate('', '12345678'), '1234567-8');
      expect(evaluate('', '123456789'), '1234567-89');
      expect(evaluate('', '1234567890'), '1234567-89.0');
      expect(evaluate('', '12345678901'), '1234567-89.01');
      expect(evaluate('', '123456789012'), '1234567-89.012');
      expect(evaluate('', '1234567890123'), '1234567-89.0123');
      expect(evaluate('', '12345678901234'), '1234567-89.0123.4');
      expect(evaluate('', '123456789012345'), '1234567-89.0123.4.5');
      expect(evaluate('', '1234567890123456'), '1234567-89.0123.4.56');
      expect(evaluate('', '12345678901234567'), '1234567-89.0123.4.56.7');
      expect(evaluate('', '123456789012345678'), '1234567-89.0123.4.56.78');
      expect(evaluate('', '1234567890123456789'), '1234567-89.0123.4.56.789');
      expect(evaluate('', '12345678901234567890'), '1234567-89.0123.4.56.7890');
    });
  });
}
