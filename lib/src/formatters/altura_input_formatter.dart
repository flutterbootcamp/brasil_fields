import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara m,cm. `1,82`
class AlturaInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 3;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    if (novoTextLength > 0) {
      final numNovo = int.tryParse(valorNovo.text.substring(0, 1));
      if (numNovo != null) {
        if (numNovo > 2) {
          return valorAntigo;
        }
      }
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength > 2) {
      newText.write(valorNovo.text.substring(0, usedSubstringIndex = 1) + ',');
      if (valorNovo.selection.end > 2) selectionIndex++;
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
