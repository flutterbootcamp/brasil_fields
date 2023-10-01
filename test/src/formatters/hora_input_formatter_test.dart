import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return HoraInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('HoraInputFormatter', () {
    test('padrao', () => expect(evaluate('', '1234'), '12:34'));
    test('limite 4 digitos', () => expect(evaluate('', '91234'), ''));
    test('hora > 24', () => expect(evaluate('', '2559'), ''));
    test('backspace', () {
      expect(evaluate('1234', '123'), '12:3');
      expect(evaluate('12:3', '12'), '12');
      expect(evaluate('12', '1'), '1');
      expect(evaluate('1', ''), '');
    });

    test('testa digitacao', () {
      expect(evaluate('', '1'), '1');
      expect(evaluate('1', '12'), '12');
      expect(evaluate('12', '123'), '12:3');
      expect(evaluate('12:3', '1234'), '12:34');
    });
  });
}
