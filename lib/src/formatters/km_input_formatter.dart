import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de `000.000`.
class KmInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    // verifica o tamanho máximo do campo
    if (newValue.text.length > 6) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    int? separatorIndex;
    final valorFinal = StringBuffer();

    switch (newValue.text.length) {
      case 4:
        separatorIndex = 1;
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 1)}.${newValue.text.substring(1, substrIndex = 3)}');
        break;
      case 5:
        separatorIndex = 2;
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 2)}.${newValue.text.substring(2, substrIndex = 4)}');
        break;
      case 6:
        separatorIndex = 3;
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 3)}.${newValue.text.substring(3, substrIndex = 5)}');
        break;
      default:
    }

    if (separatorIndex != null && posicaoCursor > separatorIndex) {
      posicaoCursor += 1;
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
