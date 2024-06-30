import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de Certidão de Nascimento: `XXXXXX XX XX XXXX X XXXXX XXX XXXXXXX XX`
class CertNascimentoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 32) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 7) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 6)} ');
      if (newValue.selection.end >= 6) posicaoCursor++;
    }
    if (newValue.text.length >= 9) {
      valorFinal.write('${newValue.text.substring(6, substrIndex = 8)} ');
      if (newValue.selection.end >= 8) posicaoCursor++;
    }
    if (newValue.text.length >= 11) {
      valorFinal.write('${newValue.text.substring(8, substrIndex = 10)} ');
      if (newValue.selection.end >= 10) posicaoCursor++;
    }
    if (newValue.text.length >= 15) {
      valorFinal.write('${newValue.text.substring(10, substrIndex = 14)} ');
      if (newValue.selection.end >= 14) posicaoCursor++;
    }
    if (newValue.text.length >= 16) {
      valorFinal.write('${newValue.text.substring(14, substrIndex = 15)} ');
      if (newValue.selection.end >= 15) posicaoCursor++;
    }
    if (newValue.text.length >= 21) {
      valorFinal.write('${newValue.text.substring(15, substrIndex = 20)} ');
      if (newValue.selection.end >= 20) posicaoCursor++;
    }
    if (newValue.text.length >= 24) {
      valorFinal.write('${newValue.text.substring(20, substrIndex = 23)} ');
      if (newValue.selection.end >= 23) posicaoCursor++;
    }
    if (newValue.text.length >= 31) {
      valorFinal.write('${newValue.text.substring(23, substrIndex = 30)} ');
      if (newValue.selection.end >= 30) posicaoCursor++;
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
