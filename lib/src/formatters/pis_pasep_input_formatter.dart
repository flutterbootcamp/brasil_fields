import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de PIS/PASEP/NIT/NIS:
/// `XXX.XXXXX.XX-X`.
class PisPasepInputFormatter extends TextInputFormatter {
  // Define o tamanho máximo do campo.
  int get maxLength => 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;

    // verifica o tamanho máximo do campo
    if (newValue.text.length > maxLength) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 4) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 3)}.');
      if (newValue.selection.end >= 3) posicaoCursor++;
    }
    if (newValue.text.length >= 9) {
      valorFinal.write('${newValue.text.substring(3, substrIndex = 8)}.');
      if (newValue.selection.end >= 8) posicaoCursor++;
    }
    if (newValue.text.length >= 11) {
      valorFinal.write('${newValue.text.substring(8, substrIndex = 10)}-');
      if (newValue.selection.end >= 10) posicaoCursor++;
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
