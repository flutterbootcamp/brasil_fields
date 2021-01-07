import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de veículos ( XXX-XXXX ).
class PlacaVeiculoFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final maxLength = 8;

  PlacaVeiculoFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final valorNovoLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (valorNovoLength > maxLength) {
      return valorAntigo;
    }

    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (valorNovoLength >= 4) {
      valorFinal.write(valorNovo.text.substring(0, substrIndex = 3) + '-');
      if (valorNovo.selection.end >= 2) selectionIndex++;
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
