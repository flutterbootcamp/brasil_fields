import 'package:flutter/services.dart';

/// Formata o valor do campo como telefone fixo ou celular.
///
/// Usa a máscara `(XX) XXXX-XXXX` para 10 dígitos e `(XX) 9XXXX-XXXX` para
/// 11 dígitos. Nesse caso, exige `9` como o primeiro dígito do número.
class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    if (newValue.text.length > 11) return oldValue;

    final newValueLength = newValue.text.length;
    if (newValueLength == 11) {
      if (newValue.text[2] != '9') {
        return oldValue;
      }
    }

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValueLength >= 1) {
      valorFinal.write('(');
      if (newValue.selection.end >= 1) posicaoCursor++;
    }

    if (newValueLength >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}) ');
      if (newValue.selection.end >= 2) posicaoCursor += 2;
    }

    if (newValue.text.length == 11) {
      if (newValueLength >= 8) {
        valorFinal.write('${newValue.text.substring(2, substrIndex = 7)}-');
        if (newValue.selection.end >= 7) posicaoCursor++;
      }
    } else {
      if (newValueLength >= 7) {
        valorFinal.write('${newValue.text.substring(2, substrIndex = 6)}-');
        if (newValue.selection.end >= 6) posicaoCursor++;
      }
    }

    if (newValueLength >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
