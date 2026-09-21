import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(KmInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('KmInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('123456')).text,
            '123.456'));
    test('testa limite 6 digitos', () {
      final oldValue = textEditingValue('123.456');
      expect(evaluate(oldValue, textEditingValue('123.4567')), oldValue);
    });

    test('backspace', () {
      var state = textEditingValue('123.456');
      for (final entry in {
        '12345': '12.345',
        '1234': '1.234',
        '123': '123',
        '12': '12',
        '1': '1'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('digitacao', () {
      var state = textEditingValue('');
      for (final entry in {
        '1': '1',
        '12': '12',
        '123': '123',
        '1234': '1.234',
        '12345': '12.345',
        '123456': '123.456'
      }.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('preserva o cursor ao inserir o separador de milhar', () {
      for (final scenario in [
        (inputOffset: 0, expectedOffset: 0),
        (inputOffset: 1, expectedOffset: 1),
        (inputOffset: 2, expectedOffset: 3),
        (inputOffset: 4, expectedOffset: 5),
      ]) {
        final actual = evaluate(
          textEditingValue(''),
          textEditingValue(
            '1234',
            selection: TextSelection.collapsed(offset: scenario.inputOffset),
          ),
        );

        expect(
          actual,
          textEditingValue(
            '1.234',
            selection: TextSelection.collapsed(offset: scenario.expectedOffset),
          ),
          reason: 'cursor de entrada em ${scenario.inputOffset}',
        );
      }
    });

    test('preserva o cursor em uma insercao no meio do valor', () {
      final actual = evaluate(
        textEditingValue(
          '12.345',
          selection: const TextSelection.collapsed(offset: 1),
        ),
        textEditingValue(
          '192.345',
          selection: const TextSelection.collapsed(offset: 2),
        ),
      );

      expect(
        actual,
        textEditingValue(
          '192.345',
          selection: const TextSelection.collapsed(offset: 2),
        ),
      );
    });

    test('composicao ativa permanece inalterada', () {
      final value = textEditingValue('1234',
          composing: const TextRange(start: 0, end: 4));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('123'), value);
    });
  });
}
