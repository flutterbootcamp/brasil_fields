import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de NUP (Numeração Única de Processos): `XXXXXXX-XX.XXXX.X.XX.XXXX`
/// Referência: [Documentação CNJ](https://www.cnj.jus.br/programas-e-acoes/numeracao-unica/)
class NUPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 20) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 8) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 7)}-');
      if (newValue.selection.end >= 7) posicaoCursor++;
    }
    if (newValue.text.length >= 10) {
      valorFinal.write('${newValue.text.substring(7, substrIndex = 9)}.');
      if (newValue.selection.end >= 9) posicaoCursor++;
    }
    if (newValue.text.length >= 14) {
      valorFinal.write('${newValue.text.substring(9, substrIndex = 13)}.');
      if (newValue.selection.end >= 13) posicaoCursor++;
    }
    if (newValue.text.length >= 15) {
      valorFinal.write('${newValue.text.substring(13, substrIndex = 14)}.');
      if (newValue.selection.end >= 14) posicaoCursor++;
    }
    if (newValue.text.length >= 17) {
      valorFinal.write('${newValue.text.substring(14, substrIndex = 16)}.');
      if (newValue.selection.end >= 16) posicaoCursor++;
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
