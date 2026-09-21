import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(HoraInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('HoraInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('1234')).text,
            '12:34'));
    test('limite 4 digitos', () {
      final oldValue = textEditingValue('12:34');
      expect(evaluate(oldValue, textEditingValue('12:345')), oldValue);
    });
    test(
        'hora > 24',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('2559')).text, ''));
    test('backspace', () {
      var state = textEditingValue('12:34');
      for (final entry
          in {'123': '12:3', '12': '12', '1': '1', '': ''}.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('testa digitacao', () {
      var state = textEditingValue('');
      for (final entry
          in {'1': '1', '12': '12', '123': '12:3', '1234': '12:34'}.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('123', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('12'), value);
    });
  });
}
