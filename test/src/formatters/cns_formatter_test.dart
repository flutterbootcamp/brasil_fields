import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CNSInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CNSInputFormatter', () {
    test('padrao',
        () => expect(evaluate('', '000111122223333'), '000 1111 2222 3333'));

    test('limite 15 digitos',
        () => expect(evaluate('', '9000111122223333'), ''));

    test('backspace', () {
      expect(evaluate('000 1111 2222 3333', '00011112222333'),
          '000 1111 2222 333');
      expect(
          evaluate('000 1111 2222 333', '0001111222233'), '000 1111 2222 33');
      expect(evaluate('000 1111 2222 33', '000111122223'), '000 1111 2222 3');
      // TODO: verificar o espaco em branco
      expect(evaluate('000 1111 2222 3', '00011112222'), '000 1111 2222 ');
      expect(evaluate('000 1111 2222', '0001111222'), '000 1111 222');
      expect(evaluate('000 1111 222', '000111122'), '000 1111 22');
      expect(evaluate('000 1111 22', '00011112'), '000 1111 2');
      expect(evaluate('000 1111 2', '0001111'), '000 1111 ');
      expect(evaluate('000 1111', '000111'), '000 111');
      expect(evaluate('000 111', '00011'), '000 11');
      expect(evaluate('000 11', '0001'), '000 1');
      expect(evaluate('000 1', '000'), '000 ');
      expect(evaluate('000', '00'), '00');
      expect(evaluate('00', '0'), '0');
      expect(evaluate('0', ''), '');
    });
  });
}
