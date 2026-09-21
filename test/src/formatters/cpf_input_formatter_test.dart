import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CpfInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CpfInputFormatter', () {
    test('padrao', () {
      final actual =
          evaluate(textEditingValue(''), textEditingValue('11122233344'));
      expect(actual.text, '111.222.333-44');
      expectCollapsedSelectionAtEnd(actual);
      expect(actual.composing, TextRange.empty);
    });
    test('limite 11 digitos preserva selecao e valor anterior', () {
      final oldValue = textEditingValue(
        '111.222.333-44',
        selection: const TextSelection(baseOffset: 4, extentOffset: 7),
      );
      expect(evaluate(oldValue, textEditingValue('111.222.333-445')), oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('111.222.333-44');
      final cases = {
        '1112223334': '111.222.333-4',
        '111222333': '111.222.333',
        '11122233': '111.222.33',
        '1112223': '111.222.3',
        '111222': '111.222',
        '11122': '111.22',
        '1112': '111.2',
        '111': '111',
        '11': '11',
        '1': '1',
        '': '',
      };
      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value = textEditingValue('1112',
          composing: const TextRange(start: 0, end: 4));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('111'), value);
    });
  });
}
