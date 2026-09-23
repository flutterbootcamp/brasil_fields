import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de CNS `XXX XXXX XXXX XXXX`.
class CNSInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    if (newValue.text.length > 15) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 3)} ');
      if (newValue.selection.end >= 4) posicaoCursor++;
    }
    if (newValue.text.length >= 7) {
      valorFinal.write('${newValue.text.substring(3, substrIndex = 7)} ');
      if (newValue.selection.end >= 8) posicaoCursor++;
    }
    if (newValue.text.length >= 11) {
      valorFinal.write('${newValue.text.substring(7, substrIndex = 11)} ');
      if (newValue.selection.end >= 12) posicaoCursor++;
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
