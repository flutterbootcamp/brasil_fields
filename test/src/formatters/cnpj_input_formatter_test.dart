import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CnpjInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CnpjInputFormatter', () {
    test(
      'padrao',
      () => expect(evaluate('', '99999999999999'), '99.999.999/9999-99'),
    );

    test(
      'limite 14 digitos',
      () => expect(evaluate('', '199999999999999'), ''),
    );

    test('backspace', () {
      expect(
          evaluate('99.999.999/9999-99', '9999999999999'), '99.999.999/9999-9');
      expect(evaluate('99.999.999/9999-9', '999999999999'), '99.999.999/9999');
      expect(evaluate('99.999.999/9999', '99999999999'), '99.999.999/999');
      expect(evaluate('99.999.999/999', '9999999999'), '99.999.999/99');
      expect(evaluate('99.999.999/99', '999999999'), '99.999.999/9');
      expect(evaluate('99.999.999/9', '99999999'), '99.999.999');
      expect(evaluate('99.999.999', '9999999'), '99.999.99');
      expect(evaluate('99.999.99', '999999'), '99.999.9');
      expect(evaluate('99.999.9', '99999'), '99.999');
      expect(evaluate('99.999', '9999'), '99.99');
      expect(evaluate('99.99', '999'), '99.9');
      expect(evaluate('99.9', '99'), '99');
      expect(evaluate('99', '9'), '9');
      expect(evaluate('9', ''), '');
    });
  });
}
