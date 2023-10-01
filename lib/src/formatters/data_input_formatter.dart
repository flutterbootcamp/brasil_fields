import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de data `01/01/1900`.
class DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 8) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}/');
      if (newValue.selection.end >= 2) posicaoCursor++;
    }
    if (newValue.text.length >= 5) {
      valorFinal.write('${newValue.text.substring(2, substrIndex = 4)}/');
      if (newValue.selection.end >= 4) posicaoCursor++;
    }
    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
