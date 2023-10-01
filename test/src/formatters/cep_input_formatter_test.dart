import 'package:brasil_fields/src/formatters/cep_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue, [bool ponto = true]) {
    return CepInputFormatter(ponto: ponto)
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CepInputFormatter', () {
    test('padrao', () => expect(evaluate('', '12345678'), '12.345-678'));
    test('limite 8 digitos', () => expect(evaluate('', '912345678'), ''));

    test('padrao [ponto: false]',
        () => expect(evaluate('', '12345678', false), '12345-678'));
    test('limite 8 digitos [ponto: false]',
        () => expect(evaluate('', '912345678', false), ''));

    test('backspace', () {
      expect(evaluate('12.345-678', '1234567'), '12.345-67');
      expect(evaluate('12.345-67', '123456'), '12.345-6');
      expect(evaluate('12.345-6', '12345'), '12.345');
      expect(evaluate('12.345', '1234'), '12.34');
      expect(evaluate('12.34', '123'), '12.3');
      expect(evaluate('12.3', '12'), '12');
      expect(evaluate('12', '1'), '1');
      expect(evaluate('1', ''), '');
    });

    test('backspace [ponto: false]', () {
      expect(evaluate('12345-678', '1234567', false), '12345-67');
      expect(evaluate('12345-67', '123456', false), '12345-6');
      expect(evaluate('12345-6', '12345', false), '12345');
      expect(evaluate('12345', '1234', false), '1234');
      expect(evaluate('1234', '123', false), '123');
      expect(evaluate('123', '12', false), '12');
      expect(evaluate('12', '1', false), '1');
      expect(evaluate('1', '', false), '');
    });
  });
}
