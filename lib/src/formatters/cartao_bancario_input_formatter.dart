import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara  0000 1111 2222 3333 .
class CartaoBancarioInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 16;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength >= 4) {
      newText.write(valorNovo.text.substring(0, usedSubstringIndex = 4) + ' ');
      if (valorNovo.selection.end >= 5) selectionIndex++;
    }
    if (novoTextLength >= 8) {
      newText.write(valorNovo.text.substring(4, usedSubstringIndex = 8) + ' ');
      if (valorNovo.selection.end >= 9) selectionIndex++;
    }
    if (novoTextLength >= 12) {
      newText.write(valorNovo.text.substring(8, usedSubstringIndex = 12) + ' ');
      if (valorNovo.selection.end >= 13) selectionIndex++;
    }
    if (novoTextLength >= usedSubstringIndex) {
      newText.write(valorNovo.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
