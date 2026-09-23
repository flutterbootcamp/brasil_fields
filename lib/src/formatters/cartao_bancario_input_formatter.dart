import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `XXXX XXXX XXXX XXXX`.
class CartaoBancarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    if (newValue.text.length > 16) return oldValue;

    int posicaoCursor = newValue.selection.end;
    final valorFinal = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      if (i % 4 == 0 && i != 0) {
        valorFinal.write(' ');
        if (posicaoCursor >= i) posicaoCursor++;
      }

      valorFinal.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
