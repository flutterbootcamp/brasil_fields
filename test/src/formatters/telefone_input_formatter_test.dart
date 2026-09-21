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
