import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CPF: `XXX.XXX.XXX-XX`
class CpfInputFormatter extends TextInputFormatter
    implements CompoundableFormatter {
  // Define o tamanho máximo do campo.
  @override
  int get maxLength => 11;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > maxLength) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 4) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 3)}.');
      if (newValue.selection.end >= 3) posicaoCursor++;
    }
    if (newValue.text.length >= 7) {
      valorFinal.write('${newValue.text.substring(3, substrIndex = 6)}.');
      if (newValue.selection.end >= 6) posicaoCursor++;
    }
    if (newValue.text.length >= 10) {
      valorFinal.write('${newValue.text.substring(6, substrIndex = 9)}-');
      if (newValue.selection.end >= 9) posicaoCursor++;
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
