import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(AlturaInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('AlturaInputFormatter', () {
    test('padrao', () {
      final actual = evaluate(textEditingValue(''), textEditingValue('175'));
      expect(actual.text, '1,75');
      expectCollapsedSelectionAtEnd(actual);
    });
    test('limite 3 digitos preserva o valor anterior', () {
      final oldValue = textEditingValue('1,75');
      expect(evaluate(oldValue, textEditingValue('1,759')), oldValue);
    });
    test(
        'valor > 3',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('3')).text, ''));
    test('backspace', () {
      var state = textEditingValue('1,75');
      for (final entry in {'17': '1,7', '1': '1', '': ''}.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('176', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('1,75'), value);
    });
  });
}
