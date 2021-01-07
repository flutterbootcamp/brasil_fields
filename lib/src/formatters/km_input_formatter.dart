import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de hora ( 000.000 ).
class KmInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 6;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();
    switch (novoTextLength) {
      case 4:
        newText.write(valorNovo.text.substring(0, usedSubstringIndex = 1) +
            '.' +
            valorNovo.text.substring(1, usedSubstringIndex = 3));
        selectionIndex += 1;
        break;
      case 5:
        newText.write(valorNovo.text.substring(0, usedSubstringIndex = 2) +
            '.' +
            valorNovo.text.substring(2, usedSubstringIndex = 4));
        selectionIndex += 1;
        break;
      case 6:
        newText.write(valorNovo.text.substring(0, usedSubstringIndex = 3) +
            '.' +
            valorNovo.text.substring(3, usedSubstringIndex = 5));
        selectionIndex += 1;
        break;
      default:
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
