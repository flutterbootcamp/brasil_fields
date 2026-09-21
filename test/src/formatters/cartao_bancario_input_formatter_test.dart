import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CartaoBancarioInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CartaoBancarioInputFormatter', () {
    test('padrao', () {
      final actual = evaluate(
        textEditingValue(''),
        textEditingValue('1111222233334444'),
      );
      expect(actual.text, '1111 2222 3333 4444');
      expectCollapsedSelectionAtEnd(actual);
    });
    test('limite 16 digitos preserva o valor anterior', () {
      final oldValue = textEditingValue('1111 2222 3333 4444');
      expect(evaluate(oldValue, textEditingValue('1111 2222 3333 44445')),
          oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('1111 2222 3333 4444');
      final cases = {
        '111122223333444': '1111 2222 3333 444',
        '11112222333344': '1111 2222 3333 44',
        '1111222233334': '1111 2222 3333 4',
        '111122223333': '1111 2222 3333',
        '11112222333': '1111 2222 333',
        '1111222233': '1111 2222 33',
        '111122223': '1111 2222 3',
        '11112222': '1111 2222',
        '1111222': '1111 222',
        '111122': '1111 22',
        '11112': '1111 2',
        '1111': '1111',
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
      final value = textEditingValue('11112',
          composing: const TextRange(start: 0, end: 5));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('1111'), value);
    });
  });
}
