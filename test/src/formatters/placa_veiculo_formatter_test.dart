import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return PlacaVeiculoInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('PlacaVeiculoInputFormatter', () {
    test('padrao', () => expect(evaluate('', 'ABC1234'), 'ABC-1234'));
    test('limite 8 digitos', () => expect(evaluate('', '9ABC1234'), ''));

    test('backspace', () {
      expect(evaluate('', 'abc1234'), 'ABC-1234');
      expect(evaluate('', 'abc123'), 'ABC-123');
      expect(evaluate('', 'abc12'), 'ABC-12');

      expect(evaluate('', 'abc1'), 'ABC-1');
      expect(evaluate('', 'abc'), 'ABC');
      expect(evaluate('', 'ab'), 'AB');
      expect(evaluate('', 'a'), 'A');
    });
    test('digitacao', () {
      expect(evaluate('', 'a'), 'A');
      expect(evaluate('', 'ab'), 'AB');
      expect(evaluate('', 'abc'), 'ABC');
      expect(evaluate('', 'abc1'), 'ABC-1');
      expect(evaluate('', 'abc12'), 'ABC-12');
      expect(evaluate('', 'abc123'), 'ABC-123');
      expect(evaluate('', 'abc1234'), 'ABC-1234');
    });
  });
}
