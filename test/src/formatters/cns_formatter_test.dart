import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CNSInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CNSInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('000111122223333'))
                .text,
            '000 1111 2222 3333'));

    test('limite 15 digitos', () {
      final oldValue = textEditingValue('000 1111 2222 3333');
      expect(evaluate(oldValue, textEditingValue('000 1111 2222 33334')),
          oldValue);
    });

    test('backspace', () {
      var state = textEditingValue('000 1111 2222 3333');
      final cases = {
        '00011112222333': '000 1111 2222 333',
        '0001111222233': '000 1111 2222 33',
        '000111122223': '000 1111 2222 3',
        '00011112222': '000 1111 2222 ',
        '0001111222': '000 1111 222',
        '000111122': '000 1111 22',
        '00011112': '000 1111 2',
        '0001111': '000 1111 ',
        '000111': '000 111',
        '00011': '000 11',
        '0001': '000 1',
        '000': '000 ',
        '00': '00',
        '0': '0',
        '': '',
      };
      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value = textEditingValue('0001',
          composing: const TextRange(start: 0, end: 4));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('000'), value);
    });
  });
}
