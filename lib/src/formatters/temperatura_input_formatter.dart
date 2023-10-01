import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara °C (ex: `10,8`).
class TemperaturaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 3) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    switch (newValue.text.length) {
      case 2:
        valorFinal.write('${newValue.text.substring(0, substrIndex = 1)},');
        if (newValue.selection.end >= 2) posicaoCursor++;
        break;
      case 3:
        valorFinal.write('${newValue.text.substring(0, substrIndex = 2)},');
        if (newValue.selection.end >= 3) posicaoCursor++;
        break;
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
