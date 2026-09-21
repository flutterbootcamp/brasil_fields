import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  TextEditingValue evaluate(
    TextEditingValue oldValue,
    TextEditingValue newValue, {
    bool moeda = false,
    int casasDecimais = 2,
  }) {
    return applyFormatterChain(
      numericFormatterChain(
        CentavosInputFormatter(
          moeda: moeda,
          casasDecimais: casasDecimais,
        ),
      ),
      oldValue,
      newValue,
    );
  }

  group('CentavosInputFormatter', () {
    for (final configuration in [
      (moeda: false, casasDecimais: 2, prefixo: ''),
      (moeda: true, casasDecimais: 2, prefixo: 'R\$ '),
      (moeda: false, casasDecimais: 3, prefixo: ''),
      (moeda: true, casasDecimais: 3, prefixo: 'R\$ '),
    ]) {
      test(
        'matriz moeda=${configuration.moeda}, '
        'casasDecimais=${configuration.casasDecimais}',
        () {
          final expected = configuration.casasDecimais == 2
              ? {
                  '1': '0,01',
                  '12': '0,12',
                  '123': '1,23',
                  '123456': '1.234,56',
                  '999999999999': '9.999.999.999,99',
                }
              : {
                  '1': '0,001',
                  '12': '0,012',
                  '123': '0,123',
                  '1234': '1,234',
                  '1234567': '1.234,567',
                  '999999999999': '999.999.999,999',
                };

          var state = textEditingValue('');
          for (final entry in expected.entries) {
            state = evaluate(
              state,
              textEditingValue(entry.key),
              moeda: configuration.moeda,
              casasDecimais: configuration.casasDecimais,
            );
            expect(state.text, '${configuration.prefixo}${entry.value}');
            expectCollapsedSelectionAtEnd(state);
          }
        },
      );
    }

    test('vazio, zero em edicao e sequencias de zeros', () {
      expect(
        evaluate(textEditingValue('12,34'), textEditingValue('')),
        textEditingValue(''),
      );
      final singleZero =
          evaluate(textEditingValue('12,34'), textEditingValue('0'));
      expect(singleZero.text, '0,');
      expectCollapsedSelectionAtEnd(singleZero);
      expect(
        evaluate(singleZero, textEditingValue('0')).text,
        isEmpty,
      );
      for (final input in ['00', '000']) {
        expect(
          evaluate(textEditingValue('12,34'), textEditingValue(input)).text,
          isEmpty,
        );
      }
    });

    test('limite preserva valor, selecao e composicao anteriores', () {
      final oldValue = textEditingValue(
        '9.999.999.999,99',
        selection: const TextSelection(baseOffset: 2, extentOffset: 8),
      );
      expect(
        evaluate(oldValue, textEditingValue('9999999999999')),
        oldValue,
      );
    });

    test('composicao ativa permanece inalterada', () {
      final formatters = numericFormatterChain(CentavosInputFormatter());
      final value = textEditingValue(
        '123',
        selection: const TextSelection.collapsed(offset: 3),
        composing: const TextRange(start: 0, end: 3),
      );
      expectActiveComposingIsUnchanged(
        formatters,
        textEditingValue('0,12'),
        value,
      );
    });
  });
}
