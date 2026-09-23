import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'formatter_test_harness.dart';

void main() {
  final formatters = numericFormatterChain(TelefoneInputFormatter());
  TextEditingValue evaluate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      applyFormatterChain(formatters, oldValue, newValue);

  group('TelefoneInputFormatter', () {
    test(
        'padrao [9 digito]',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('61987654321'))
                .text,
            '(61) 98765-4321'));
    test(
        'padrao',
        () => expect(
            evaluate(textEditingValue(''), textEditingValue('6187654321')).text,
            '(61) 8765-4321'));

    test('mantém a regra legada do nono dígito para celulares', () {
      final oldValue = textEditingValue('(61) 1234-5678');
      expect(
        evaluate(oldValue, textEditingValue('61123456789')),
        oldValue,
      );
    });

    test('limite 11 digitos', () {
      final oldValue = textEditingValue('(61) 98765-4321');
      expect(
          evaluate(oldValue, textEditingValue('(61) 98765-43210')), oldValue);
    });
    test('backspace', () {
      var state = textEditingValue('(61) 98765-4321');
      for (final entry in _telefoneCases.entries) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });

    test('digitacao', () {
      var state = textEditingValue('');
      final cases = _telefoneCases.entries.toList().reversed.skip(1).toList()
        ..add(const MapEntry('61987654321', '(61) 98765-4321'));
      for (final entry in cases) {
        state = evaluate(state, textEditingValue(entry.key));
        expect(state.text, entry.value);
      }
    });
    test('composicao ativa permanece inalterada', () {
      final value =
          textEditingValue('619', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(
          formatters, textEditingValue('61'), value);
    });
  });

  group('TelefoneFixoInputFormatter', () {
    final fixo = numericFormatterChain(TelefoneFixoInputFormatter());

    test('formata até 10 dígitos e limita o tamanho', () {
      expect(
        applyFormatterChain(
          fixo,
          textEditingValue(''),
          textEditingValue('6187654321'),
        ).text,
        '(61) 8765-4321',
      );

      final oldValue = textEditingValue('(61) 8765-4321');
      expect(
        applyFormatterChain(fixo, oldValue, textEditingValue('61876543210')),
        oldValue,
      );
    });

    test('cursor permanece no fim durante a digitação', () {
      var value = textEditingValue('');
      for (final digit in '6187654321'.split('')) {
        value = applyFormatterChain(
          fixo,
          value,
          textEditingValue('${value.text.replaceAll(RegExp(r'\D'), '')}$digit'),
        );
        expectCollapsedSelectionAtEnd(value);
      }
      expect(value.text, '(61) 8765-4321');
    });

    test('preserva composição ativa', () {
      final value =
          textEditingValue('619', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(fixo, textEditingValue('61'), value);
    });

    test('cursor avança sobre dígitos ao apagar separadores da máscara', () {
      final oldValue = textEditingValue('(61) 9876-5');
      final afterParenthesis = applyFormatterChain(
        fixo,
        oldValue,
        textEditingValue(
          '6198765',
          selection: const TextSelection.collapsed(offset: 2),
        ),
      );
      expect(afterParenthesis.text, '(61) 9876-5');
      expect(
          afterParenthesis.selection, const TextSelection.collapsed(offset: 3));

      final afterHyphen = applyFormatterChain(
        fixo,
        oldValue,
        textEditingValue(
          '6198765',
          selection: const TextSelection.collapsed(offset: 6),
        ),
      );
      expect(afterHyphen.text, '(61) 9876-5');
      expect(afterHyphen.selection, const TextSelection.collapsed(offset: 9));
    });
  });

  group('CelularInputFormatter', () {
    final celular = numericFormatterChain(CelularInputFormatter());

    test('aplica a máscara móvel desde o início e aceita 11 dígitos', () {
      expect(
        applyFormatterChain(
          celular,
          textEditingValue(''),
          textEditingValue('6198765'),
        ).text,
        '(61) 98765',
      );
      expect(
        applyFormatterChain(
          celular,
          textEditingValue(''),
          textEditingValue('61987654321'),
        ).text,
        '(61) 98765-4321',
      );
    });

    test('limita a 11 dígitos e preserva composição ativa', () {
      final oldValue = textEditingValue('(61) 98765-4321');
      expect(
        applyFormatterChain(
            celular, oldValue, textEditingValue('619876543210')),
        oldValue,
      );

      final value =
          textEditingValue('619', composing: const TextRange(start: 0, end: 3));
      expectActiveComposingIsUnchanged(celular, textEditingValue('61'), value);
    });

    test('permite apagar dígitos sem perder o texto restante', () {
      expect(
        applyFormatterChain(
          celular,
          textEditingValue('(61) 98765-4321'),
          textEditingValue('6198765432'),
        ).text,
        '(61) 98765-432',
      );
    });
  });

  test('TelefoneOuCelularInputFormatter escolhe a máscara pelo tamanho', () {
    final automatico = numericFormatterChain(TelefoneOuCelularInputFormatter());
    expect(
      applyFormatterChain(
        automatico,
        textEditingValue(''),
        textEditingValue('6187654321'),
      ).text,
      '(61) 8765-4321',
    );
    expect(
      applyFormatterChain(
        automatico,
        textEditingValue(''),
        textEditingValue('61987654321'),
      ).text,
      '(61) 98765-4321',
    );
  });
}

const _telefoneCases = {
  '6198765432': '(61) 9876-5432',
  '619876543': '(61) 9876-543',
  '61987654': '(61) 9876-54',
  '6198765': '(61) 9876-5',
  '619876': '(61) 9876',
  '61987': '(61) 987',
  '6198': '(61) 98',
  '619': '(61) 9',
  '61': '(61',
  '6': '(6',
  '': '',
};
