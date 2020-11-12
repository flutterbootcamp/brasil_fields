import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara MM/AA
class ValidadeCartaoInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

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

    switch (novoTextLength) {
      case 1:
        final hora = int.tryParse(valorNovo.text.substring(0, 1));
        if (hora >= 2) return valorAntigo;
        break;
      case 2:
        final hora = int.tryParse(valorNovo.text.substring(0, 2));
        if (hora >= 13) return valorAntigo;
        break;
      case 3:
      case 4:
        newText
            .write(valorNovo.text.substring(0, usedSubstringIndex = 2) + '/');
        if (valorNovo.selection.end >= 2) selectionIndex++;
        break;
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
