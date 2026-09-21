import 'package:brasil_fields/src/formatters/nup_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(NUPInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('NUPInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''),
                    textEditingValue('12345678901234567890'))
                .text,
            '1234567-89.0123.4.56.7890'));
    test('limite 20 digitos', () {
      final oldValue = textEditingValue('1234567-89.0123.4.56.7890');
      expect(evaluate(oldValue, textEditingValue('1234567-89.0123.4.56.78901')),
          oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('1234567-89.0123.4.56.7890');
      final cases = {
        '12345678901234567890': '1234567-89.0123.4.56.7890',
        '1234567890123456789': '1234567-89.0123.4.56.789',
        '123456789012345678': '1234567-89.0123.4.56.78',
        '12345678901234567': '1234567-89.0123.4.56.7',
        '1234567890123456': '1234567-89.0123.4.56',
        '123456789012345': '1234567-89.0123.4.5',
        '12345678901234': '1234567-89.0123.4',
        '1234567890123': '1234567-89.0123',
        '123456789012': '1234567-89.012',
        '12345678901': '1234567-89.01',
        '1234567890': '1234567-89.0',
        '123456789': '1234567-89',
        '12345678': '1234567-8',
        '1234567': '1234567',
        '123456': '123456',
        '12345': '12345',
        '1234': '1234',
        '123': '123',
        '12': '12',
        '1': '1',
      };
      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('digitacao', () {
      var state = textEditingValue('');
      final expected = [
        '1',
        '12',
        '123',
        '1234',
        '12345',
        '123456',
        '1234567',
        '1234567-8',
        '1234567-89',
        '1234567-89.0',
        '1234567-89.01',
        '1234567-89.012',
        '1234567-89.0123',
        '1234567-89.0123.4',
        '1234567-89.0123.4.5',
        '1234567-89.0123.4.56',
        '1234567-89.0123.4.56.7',
        '1234567-89.0123.4.56.78',
        '1234567-89.0123.4.56.789',
        '1234567-89.0123.4.56.7890',
      ];
      for (var length = 1; length <= 20; length++) {
        state = evaluate(state,
            textEditingValue('12345678901234567890'.substring(0, length)));
        expect(state.text, expected[length - 1]);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value = textEditingValue('12345678',
          composing: const TextRange(start: 0, end: 8));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('1234567'), value);
    });
  });
}
