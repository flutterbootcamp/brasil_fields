import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara CEST `XX.XXX.XX`.
class CESTInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 7) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}.');
      if (newValue.selection.end >= 2) posicaoCursor++;
    }

    if (newValue.text.length >= 6) {
      valorFinal.write('${newValue.text.substring(2, substrIndex = 5)}.');
      if (newValue.selection.end >= 5) posicaoCursor++;
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
