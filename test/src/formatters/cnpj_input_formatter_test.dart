import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(CnpjInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('CnpjInputFormatter', () {
    test(
      'padrao',
      () => expect(
          evaluate(textEditingValue(''), textEditingValue('99999999999999'))
              .text,
          '99.999.999/9999-99'),
    );

    test(
      'limite 14 digitos',
      () {
        final oldValue = textEditingValue('99.999.999/9999-99');
        expect(evaluate(oldValue, textEditingValue('99.999.999/9999-999')),
            oldValue);
      },
    );

    test('backspace', () {
      var state = textEditingValue('99.999.999/9999-99');
      final cases = {
        '9999999999999': '99.999.999/9999-9',
        '999999999999': '99.999.999/9999',
        '99999999999': '99.999.999/999',
        '9999999999': '99.999.999/99',
        '999999999': '99.999.999/9',
        '99999999': '99.999.999',
        '9999999': '99.999.99',
        '999999': '99.999.9',
        '99999': '99.999',
        '9999': '99.99',
        '999': '99.9',
        '99': '99',
        '9': '9',
        '': '',
      };
      for (final entry in cases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('substituicao no limite continua aceita', () {
      final oldValue = textEditingValue(
        '99.999.999/9999-99',
        selection: const TextSelection(baseOffset: 0, extentOffset: 18),
      );
      final actual = evaluate(oldValue, textEditingValue('12345678901234'));
      expect(actual.text, '12.345.678/9012-34');
      expectCollapsedSelectionAtEnd(actual);
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('999', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('99'), value);
    });
  });
}
