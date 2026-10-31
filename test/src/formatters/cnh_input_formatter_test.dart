import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CNHInputFormatter());
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CNHInputFormatter', () {
    test('mantém os 11 dígitos sem separadores', () {
      final actual = evaluate(
        textEditingValue(''),
        textEditingValue('18718682003'),
      );

      expect(actual.text, '18718682003');
      expectCollapsedSelectionAtEnd(actual);
      expect(actual.composing, TextRange.empty);
    });

    test('a cadeia numérica descarta caracteres não numéricos', () {
      final actual = evaluate(
        textEditingValue(''),
        textEditingValue('187.186.820-03'),
      );

      expect(actual.text, '18718682003');
    });

    test('digitação sequencial preserva o cursor no fim', () {
      var state = textEditingValue('');
      const raw = '18718682003';

      for (var length = 1; length <= raw.length; length++) {
        state = evaluate(state, textEditingValue(raw.substring(0, length)));
        expect(state.text, raw.substring(0, length));
        expectCollapsedSelectionAtEnd(state);
      }
    });

    test('backspace remove um dígito por vez', () {
      var state = textEditingValue('18718682003');
      const cases = <String>[
        '1871868200',
        '187186820',
        '18718682',
        '1871868',
        '187',
        '18',
        '1',
        '',
      ];

      for (final expected in cases) {
        state = evaluate(state, textEditingValue(expected));
        expect(state.text, expected);
        expectCollapsedSelectionAtEnd(state);
      }
    });

    test('edição no meio preserva a posição do cursor', () {
      final actual = evaluate(
        textEditingValue('18718682003'),
        textEditingValue(
          '18918682003',
          selection: const TextSelection.collapsed(offset: 3),
        ),
      );

      expect(actual.text, '18918682003');
      expect(actual.selection, const TextSelection.collapsed(offset: 3));
    });

    test('limite de 11 dígitos preserva valor e seleção anteriores', () {
      final oldValue = textEditingValue(
        '18718682003',
        selection: const TextSelection(baseOffset: 3, extentOffset: 8),
      );

      expect(evaluate(oldValue, textEditingValue('187186820033')), oldValue);
    });

    test('composição ativa permanece inalterada', () {
      final value = textEditingValue(
        '1871',
        composing: const TextRange(start: 0, end: 4),
      );

      expectActiveComposingIsUnchanged(
        formatters,
        textEditingValue('187'),
        value,
      );
    });
  });
}
