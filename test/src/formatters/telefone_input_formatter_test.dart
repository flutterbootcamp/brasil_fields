import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return TelefoneInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('TelefoneInputFormatter', () {
    test('padrao [9 digito]',
        () => expect(evaluate('', '61987654321'), '(61) 98765-4321'));
    test('padrao', () => expect(evaluate('', '6187654321'), '(61) 8765-4321'));

    test('limite 11 digitos', () => expect(evaluate('', '961987654321'), ''));
    test('backspace', () {
      expect(evaluate('', '6198765432'), '(61) 9876-5432');
      expect(evaluate('', '619876543'), '(61) 9876-543');
      expect(evaluate('', '61987654'), '(61) 9876-54');
      expect(evaluate('', '6198765'), '(61) 9876-5');
      expect(evaluate('', '619876'), '(61) 9876');
      expect(evaluate('', '61987'), '(61) 987');
      expect(evaluate('', '6198'), '(61) 98');
      expect(evaluate('', '619'), '(61) 9');
      expect(evaluate('', '61'), '(61');
      expect(evaluate('', '6'), '(6');
      expect(evaluate('', ''), '');
    });

    test('digitacao', () {
      expect(evaluate('', '6'), '(6');
      expect(evaluate('', '61'), '(61');
      expect(evaluate('', '619'), '(61) 9');
      expect(evaluate('', '6198'), '(61) 98');
      expect(evaluate('', '61987'), '(61) 987');
      expect(evaluate('', '619876'), '(61) 9876');
      expect(evaluate('', '6198765'), '(61) 9876-5');
      expect(evaluate('', '61987654'), '(61) 9876-54');
      expect(evaluate('', '619876543'), '(61) 9876-543');
      expect(evaluate('', '6198765432'), '(61) 9876-5432');
      expect(evaluate('', '61987654321'), '(61) 98765-4321');
    });
  });
}
