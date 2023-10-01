import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return CartaoBancarioInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('CartaoBancarioInputFormatter', () {
    test('padrao',
        () => expect(evaluate('', '1111222233334444'), '1111 2222 3333 4444'));
    test('limite 16 digitos',
        () => expect(evaluate('', '11112223334445555'), ''));
    test('backspace', () {
      expect(evaluate('', '111122223333444'), '1111 2222 3333 444');
      expect(evaluate('', '11112222333344'), '1111 2222 3333 44');
      expect(
        evaluate('', '1111222233334'),
        '1111 2222 3333 4',
      );
      expect(evaluate('', '111122223333'), '1111 2222 3333');
      expect(evaluate('', '11112222333'), '1111 2222 333');
      expect(evaluate('', '1111222233'), '1111 2222 33');
      expect(evaluate('', '111122223'), '1111 2222 3');
      expect(evaluate('', '11112222'), '1111 2222');
      expect(evaluate('', '1111222'), '1111 222');
      expect(evaluate('', '111122'), '1111 22');
      expect(evaluate('', '11112'), '1111 2');
      expect(evaluate('', '1111'), '1111');
      expect(evaluate('', '111'), '111');
      expect(evaluate('', '11'), '11');
      expect(evaluate('', '1'), '1');
      expect(evaluate('', ''), '');
    });
  });
}
