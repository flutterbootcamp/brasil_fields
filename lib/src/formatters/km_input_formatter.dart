import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de `000.000`.
class KmInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 6) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    switch (newValue.text.length) {
      case 4:
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 1)}.${newValue.text.substring(1, substrIndex = 3)}');
        posicaoCursor += 1;
        break;
      case 5:
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 2)}.${newValue.text.substring(2, substrIndex = 4)}');
        posicaoCursor += 1;
        break;
      case 6:
        valorFinal.write(
            '${newValue.text.substring(0, substrIndex = 3)}.${newValue.text.substring(3, substrIndex = 5)}');
        posicaoCursor += 1;
        break;
      default:
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
