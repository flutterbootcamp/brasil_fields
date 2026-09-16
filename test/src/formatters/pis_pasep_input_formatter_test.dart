import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue) {
    return PisPasepInputFormatter()
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('PisPasepInputFormatter', () {
    test('padrao', () => expect(evaluate('', '12012345672'), '120.12345.67-2'));
    test('limite 11 digitos', () => expect(evaluate('', '120123456722'), ''));
    test('digitacao', () {
      expect(evaluate('', '1'), '1');
      expect(evaluate('1', '12'), '12');
      expect(evaluate('12', '120'), '120');
      expect(evaluate('120', '1201'), '120.1');
      expect(evaluate('120.1', '12012'), '120.12');
      expect(evaluate('120.12', '120123'), '120.123');
      expect(evaluate('120.123', '1201234'), '120.1234');
      expect(evaluate('120.1234', '12012345'), '120.12345');
      expect(evaluate('120.12345', '120123456'), '120.12345.6');
      expect(evaluate('120.12345.6', '1201234567'), '120.12345.67');
      expect(evaluate('120.12345.67', '12012345672'), '120.12345.67-2');
    });
    test('backspace', () {
      expect(evaluate('120.12345.67-2', '1201234567'), '120.12345.67');
      expect(evaluate('120.12345.67', '120123456'), '120.12345.6');
      expect(evaluate('120.12345.6', '12012345'), '120.12345');
      expect(evaluate('120.12345', '1201234'), '120.1234');
      expect(evaluate('120.1', '120'), '120');
      expect(evaluate('120', '12'), '12');
      expect(evaluate('12', '1'), '1');
      expect(evaluate('1', ''), '');
    });
    test('posicao do cursor', () {
      final resultado = PisPasepInputFormatter().formatEditUpdate(
        const TextEditingValue(text: '1201234567'),
        const TextEditingValue(
          text: '12012345672',
          selection: TextSelection.collapsed(offset: 11),
        ),
      );

      expect(resultado.text, '120.12345.67-2');
      expect(resultado.selection.baseOffset, 14);
    });
  });
}
