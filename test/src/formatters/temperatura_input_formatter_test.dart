import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(TemperaturaInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('description', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('246')).text,
            '24,6'));
    test('limite 3 digitos', () {
      final oldValue = textEditingValue('24,6');
      expect(evaluate(oldValue, textEditingValue('24,67')), oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('24,6');
      for (final entry in {'24': '2,4', '2': '2', '': ''}.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('24', composing: const TextRange(start: 0, end: 2));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('2'), value);
    });
  });
}
