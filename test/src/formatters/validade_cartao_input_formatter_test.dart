import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue, [
    int maxLength = 6,
  ]) =>
      applyFormatterChain(
        numericFormatterChain(
            ValidadeCartaoInputFormatter(maxLength: maxLength)),
        oldValue,
        newValue,
      );

  group('ValidadeCartaoInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('0928')).text,
            '09/28'));
    test(
        'padrao [maxLength: 6]',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('092028'), 6).text,
            '09/2028'));

    test('maxLength invalido', () {
      expect(
        () => evaluate(textEditingValue(''), textEditingValue(''), 7),
        throwsAssertionError,
      );
    });

    test('backspace', () {
      var state = textEditingValue('09/28');
      for (final entry
          in {'092': '09/2', '09': '09', '0': '0', '': ''}.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('backspace [maxLength: 6]', () {
      var state = textEditingValue('09/2028');
      for (final entry in {
        '09202': '09/202',
        '0920': '09/20',
        '092': '09/2',
        '09': '09',
        '0': '0',
        '': ''
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key), 6);
        expect(state.text, entry.value);
      }
    });

    test('digitacao [maxLength: 6]', () {
      var state = textEditingValue('');
      for (final entry in {
        '0': '0',
        '09': '09',
        '092': '09/2',
        '0920': '09/20',
        '09202': '09/202',
        '092029': '09/2029'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key), 6);
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final formatters = numericFormatterChain(ValidadeCartaoInputFormatter());
      final value =
          textEditingValue('092', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('09'), value);
    });
  });
}
