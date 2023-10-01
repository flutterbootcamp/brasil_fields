import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CpfInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CpfInputFormatter', () {
    test('padrao', () => expect(evaluate('', '11122233344'), '111.222.333-44'));
    test('limite 11 digitos', () => expect(evaluate('', '911122233344'), ''));
    test('backspace', () {
      expect(evaluate('111.222.333-44', '1112223334'), '111.222.333-4');
      expect(evaluate('111.222.333-4', '111222333'), '111.222.333');
      expect(evaluate('111.222.333', '11122233'), '111.222.33');
      expect(evaluate('111.222.33', '1112223'), '111.222.3');
      expect(evaluate('111.222.3', '111222'), '111.222');
      expect(evaluate('111.222', '11122'), '111.22');
      expect(evaluate('111.22', '1112'), '111.2');
      expect(evaluate('111.2', '111'), '111');
      expect(evaluate('111', '11'), '11');
      expect(evaluate('11', '1'), '1');
      expect(evaluate('1', ''), '');
    });
  });
}
