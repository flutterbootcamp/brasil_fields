import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = alphaNumericFormatterChain(PlacaVeiculoInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('PlacaVeiculoInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('ABC1234')).text,
            'ABC-1234'));
    test('limite 7 caracteres', () {
      final oldValue = textEditingValue('ABC-1234');
      expect(evaluate(oldValue, textEditingValue('ABC-12345')), oldValue);
    });

    test('backspace', () {
      var state = textEditingValue('ABC-1234');
      for (final entry in {
        'abc1234': 'ABC-1234',
        'abc123': 'ABC-123',
        'abc12': 'ABC-12',
        'abc1': 'ABC-1',
        'abc': 'ABC',
        'ab': 'AB',
        'a': 'A'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('digitacao', () {
      var state = textEditingValue('');
      for (final entry in {
        'a': 'A',
        'ab': 'AB',
        'abc': 'ABC',
        'abc1': 'ABC-1',
        'abc12': 'ABC-12',
        'abc123': 'ABC-123',
        'abc1234': 'ABC-1234'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('abc', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('AB'), value);
    });
  });
}
