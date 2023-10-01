import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `(99) 99999-9999`.
///
/// _Nono dígito automático_.
class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Verifica o tamanho máximo do campo.
    if (newValue.text.length > 11) return oldValue;

    final newValueLength = newValue.text.length;
    if (newValueLength == 11) {
      if (newValue.text.toString()[2] != '9') {
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
