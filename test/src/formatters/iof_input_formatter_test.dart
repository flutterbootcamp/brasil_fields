import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(IOFInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('IOFInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('1234567')).text,
            '1,234567'));
    test('limite 7 digitos', () {
      final oldValue = textEditingValue('1,234567');
      expect(evaluate(oldValue, textEditingValue('1,2345678')), oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('1,234567');
      for (final entry in {
        '123456': '1,23456',
        '12345': '1,2345',
        '1234': '1,234',
        '123': '1,23',
        '12': '1,2',
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
