import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CESTInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CESTInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('1234567')).text,
            '12.345.67'));
    test('limite 7 digitos preserva o valor anterior', () {
      final oldValue = textEditingValue('12.345.67');
      expect(evaluate(oldValue, textEditingValue('12.345.678')), oldValue);
    });

    test('backspace', () {
      var state = textEditingValue('12.345.67');
      for (final entry in {
        '123456': '12.345.6',
        '12345': '12.345',
        '1234': '12.34',
        '123': '12.3',
        '12': '12',
        '1': '1',
        '': '',
      }.entries) {
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
