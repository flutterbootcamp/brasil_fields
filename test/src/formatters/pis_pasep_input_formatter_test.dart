import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(PisPasepInputFormatter());
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('PisPasepInputFormatter', () {
    test('formata pela cadeia numérica suportada', () {
      final actual = evaluate(
        textEditingValue(''),
        textEditingValue('120a12345672'),
      );

      expect(actual.text, '120.12345.67-2');
      expectCollapsedSelectionAtEnd(actual);
      expect(actual.composing, TextRange.empty);
    });

    test('digitação sequencial preserva o cursor no fim', () {
      var state = textEditingValue('');
      const raw = '12012345672';
      const expected = <String>[
        '1',
        '12',
        '120',
        '120.1',
        '120.12',
        '120.123',
        '120.1234',
        '120.12345',
        '120.12345.6',
        '120.12345.67',
        '120.12345.67-2',
      ];

      for (var length = 1; length <= raw.length; length++) {
        state = evaluate(state, textEditingValue(raw.substring(0, length)));
        expect(state.text, expected[length - 1]);
        expectCollapsedSelectionAtEnd(state);
      }
    });

    test('backspace remove dígitos através dos separadores', () {
      var state = textEditingValue('120.12345.67-2');
      const cases = <String, String>{
        '1201234567': '120.12345.67',
        '120123456': '120.12345.6',
        '12012345': '120.12345',
        '1201234': '120.1234',
        '120': '120',
        '12': '12',
        '1': '1',
        '': '',
      };

      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
        expectCollapsedSelectionAtEnd(state);
      }
    });

    test('edição no meio remapeia o cursor após o separador', () {
      final actual = evaluate(
        textEditingValue('120.12345.67-2'),
        textEditingValue(
          '12092345672',
          selection: const TextSelection.collapsed(offset: 4),
        ),
      );

      expect(actual.text, '120.92345.67-2');
      expect(actual.selection, const TextSelection.collapsed(offset: 5));
    });

    test('limite de 11 dígitos preserva valor e seleção anteriores', () {
      final oldValue = textEditingValue(
        '120.12345.67-2',
        selection: const TextSelection(baseOffset: 4, extentOffset: 9),
      );

      expect(evaluate(oldValue, textEditingValue('120123456722')), oldValue);
    });

    test('composição ativa permanece inalterada', () {
      final value = textEditingValue(
        '1201',
        composing: const TextRange(start: 0, end: 4),
      );

      expectActiveComposingIsUnchanged(
        formatters,
        textEditingValue('120'),
        value,
      );
    });
  });
}
