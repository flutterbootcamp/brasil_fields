import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CEP ( XX.XXX-XXX ).
class CepInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final maxLength = 8;

  /// [ponto] indica se o formato do CEP deve utilizar `.` ou não.
  final bool ponto;

  CepInputFormatter({this.ponto = true});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAnterior, TextEditingValue novoValor) {
    final novoValorLength = novoValor.text.length;
    var selectionIndex = novoValor.selection.end;

    if (novoValorLength > maxLength) {
      return valorAnterior;
    }
    var substrInicio = 2;
    if (!ponto) {
      substrInicio = 0;
    }

    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (novoValorLength >= 3 && ponto) {
      valorFinal.write(novoValor.text.substring(0, substrIndex = 2) + '.');
      if (novoValor.selection.end >= 2) selectionIndex++;
    }
    if (novoValorLength >= 6) {
      valorFinal
          .write(novoValor.text.substring(substrInicio, substrIndex = 5) + '-');
      if (novoValor.selection.end >= 5) selectionIndex++;
    }

    if (novoValorLength >= substrIndex) {
      valorFinal.write(novoValor.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
