import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara ( (99) 99999-9999 ).
///
/// Nono dígito automático.
class TelefoneInputFormatter extends TextInputFormatter {
  TelefoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;

    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength == 11) {
      if (valorNovo.text.toString()[2] != '9') {
        return valorAntigo;
      }
    }

    /// Verifica o tamanho máximo do campo.
    if (novoTextLength > 11) {
      return valorAntigo;
    }

    var usedSubstringIndex = 0;

    final newText = StringBuffer();

    if (novoTextLength >= 1) {
      newText.write('(');
      if (valorNovo.selection.end >= 1) selectionIndex++;
    }

    if (novoTextLength >= 3) {
      newText.write(valorNovo.text.substring(0, usedSubstringIndex = 2) + ') ');
      if (valorNovo.selection.end >= 2) selectionIndex += 2;
    }

    if (valorNovo.text.length == 11) {
      if (novoTextLength >= 8) {
        newText.write(valorNovo.text.substring(2, usedSubstringIndex = 7) + '-');
        if (valorNovo.selection.end >= 7) selectionIndex++;
      }
    } else {
      if (novoTextLength >= 7) {
        newText.write(valorNovo.text.substring(2, usedSubstringIndex = 6) + '-');
        if (valorNovo.selection.end >= 6) selectionIndex++;
      }
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
