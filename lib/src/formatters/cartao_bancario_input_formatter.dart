import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `0000 1111 2222 3333`.
class CartaoBancarioInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 16) return oldValue;

    int posicaoCursor = newValue.selection.end;
    final valorFinal = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      // adiciona espaco em branco a cada 4 digitos
      if (i % 4 == 0 && i != 0) {
        valorFinal.write(' ');
        // incrementa a posicao do cursor
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
