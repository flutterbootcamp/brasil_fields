import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue, [
    bool moeda = false,
  ]) =>
      applyFormatterChain(
        numericFormatterChain(RealInputFormatter(moeda: moeda)),
        oldValue,
        newValue,
      );

  group('RealInputFormatter', () {
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('111222333444'))
                .text,
            '111.222.333.444'));
    test(
      'padrao [moeda: true]',
      () => expect(
          evaluate(textEditingValue(''), textEditingValue('111222333444'), true)
              .text,
          'R\$ 111.222.333.444'),
    );
    test('limite 12 digitos', () {
      final oldValue = textEditingValue('111.222.333.444');
      expect(
          evaluate(oldValue, textEditingValue('111.222.333.4445')), oldValue);
    });
    test(
      'limite 12 digitos [moeda: true]',
      () {
        final oldValue = textEditingValue('R\$ 111.222.333.444');
        expect(
            evaluate(oldValue, textEditingValue('R\$ 111.222.333.4445'), true),
            oldValue);
      },
    );

    test('backspace', () {
      var state = textEditingValue('111.222.333.444');
      for (final entry in _realCases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('backspace [moeda: true]', () {
      var state = textEditingValue('R\$ 111.222.333.444');
      for (final entry in _realCases.entries) {
        state = evaluate(state, textEditingValue(entry.key), true);
        expect(state.text, entry.value.isEmpty ? '' : 'R\$ ${entry.value}');
      }
    });

    test('digitacao', () {
      var state = textEditingValue('');
      for (final entry in _realCases.entries.toList().reversed.skip(1)) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('digitacao [moeda: true]', () {
      var state = textEditingValue('');
      for (final entry in _realCases.entries.toList().reversed.skip(1)) {
        state = evaluate(state, textEditingValue(entry.key), true);
        expect(state.text, 'R\$ ${entry.value}');
      }
    });
    test('composicao ativa permanece inalterada', () {
      final formatters = numericFormatterChain(RealInputFormatter());
      final value = textEditingValue('1234',
          composing: const TextRange(start: 0, end: 4));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('123'), value);
    });
  });
}

const _realCases = {
  '12345678900': '12.345.678.900',
  '1234567890': '1.234.567.890',
  '123456789': '123.456.789',
  '12345678': '12.345.678',
  '1234567': '1.234.567',
  '123456': '123.456',
  '12345': '12.345',
  '1234': '1.234',
  '123': '123',
  '12': '12',
  '1': '1',
  '': '',
};
