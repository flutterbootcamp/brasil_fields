import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de NCM: `XXXX.XX.XX`
class NCMInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 8) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 5) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 4)}.');
      if (newValue.selection.end >= 4) posicaoCursor++;
    }
    if (newValue.text.length >= 7) {
      valorFinal.write('${newValue.text.substring(4, substrIndex = 6)}.');
      if (newValue.selection.end >= 6) posicaoCursor++;
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
