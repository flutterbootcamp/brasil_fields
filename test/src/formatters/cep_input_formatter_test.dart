import 'package:brasil_fields/src/formatters/cep_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue, [
    bool ponto = true,
  ]) =>
      applyFormatterChain(
        numericFormatterChain(CepInputFormatter(ponto: ponto)),
        oldValue,
        newValue,
      );

  group('CepInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('12345678')).text,
            '12.345-678'));
    test('limite 8 digitos', () {
      final oldValue = textEditingValue('12.345-678');
      expect(evaluate(oldValue, textEditingValue('12.345-6789')), oldValue);
    });

    test(
        'padrao [ponto: false]',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('12345678'), false)
                .text,
            '12345-678'));
    test('limite 8 digitos [ponto: false]', () {
      final oldValue = textEditingValue('12345-678');
      expect(
          evaluate(oldValue, textEditingValue('12345-6789'), false), oldValue);
    });

    test('backspace', () {
      var state = textEditingValue('12.345-678');
      for (final entry in {
        '1234567': '12.345-67',
        '123456': '12.345-6',
        '12345': '12.345',
        '1234': '12.34',
        '123': '12.3',
        '12': '12',
        '1': '1',
        '': '',
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('backspace [ponto: false]', () {
      var state = textEditingValue('12345-678');
      for (final entry in {
        '1234567': '12345-67',
        '123456': '12345-6',
        '12345': '12345',
        '1234': '1234',
        '123': '123',
        '12': '12',
        '1': '1',
        '': '',
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key), false);
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final formatters = numericFormatterChain(CepInputFormatter());
      final value =
          textEditingValue('123', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('12'), value);
    });
  });
}
