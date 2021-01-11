import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CEP ( XX.XXX-XXX ).
class CepInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final maxLength = 8;

  /// [ponto] indica se o formato do CEP deve utilizar `.` ou não.
  final bool ponto;

  CepInputFormatter({this.ponto = true});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final valorNovoLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (valorNovoLength > maxLength) {
      return valorAntigo;
    }
    var substrInicio = 2;
    if (!ponto) {
      substrInicio = 0;
    }

    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (valorNovoLength >= 3 && ponto) {
      valorFinal.write(valorNovo.text.substring(0, substrIndex = 2) + '.');
      if (valorNovo.selection.end >= 2) selectionIndex++;
    }
    if (valorNovoLength >= 6) {
      valorFinal.write(valorNovo.text.substring(substrInicio, substrIndex = 5) + '-');
      if (valorNovo.selection.end >= 5) selectionIndex++;
    }

    if (valorNovoLength >= substrIndex) {
      valorFinal.write(valorNovo.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
