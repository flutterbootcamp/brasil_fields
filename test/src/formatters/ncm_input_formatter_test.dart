import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(NCMInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('NCMInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('12345678')).text,
            '1234.56.78'));
    test('limite 8 digitos', () {
      final oldValue = textEditingValue('1234.56.78');
      expect(evaluate(oldValue, textEditingValue('1234.56.789')), oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('1234.56.78');
      for (final entry in {
        '1234567': '1234.56.7',
        '123456': '1234.56',
        '12345': '1234.5',
        '1234': '1234',
        '123': '123',
        '12': '12',
        '1': '1'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('digitacao', () {
      var state = textEditingValue('');
      for (final entry in {
        '1': '1',
        '12': '12',
        '123': '123',
        '1234': '1234',
        '12345': '1234.5',
        '123456': '1234.56',
        '1234567': '1234.56.7'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value = textEditingValue('12345',
          composing: const TextRange(start: 0, end: 5));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('1234'), value);
    });
  });
}
