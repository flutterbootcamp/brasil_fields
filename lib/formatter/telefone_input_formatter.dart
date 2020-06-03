import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara ( (99) 99999-9999 ).
///
/// Nono dígito automático.
class TelefoneInputFormatter extends TextInputFormatter {
  TelefoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;

    var selectionIndex = newValue.selection.end;

    //verifica se é celular ou telefone fixo
    if (newTextLength == 11) {
      if (newValue.text.toString()[2] != '9') {
        return oldValue;
      }
    }

    /// Verifica o tamanho máximo do campo.
    if (newTextLength > 11) {
      return oldValue;
    }

    var usedSubstringIndex = 0;

    final newText = StringBuffer();

    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ') ');
      if (newValue.selection.end >= 2) selectionIndex += 2;
    }

    if (newValue.text.length == 11) {
      if (newTextLength >= 8) {
        newText.write(newValue.text.substring(2, usedSubstringIndex = 7) + '-');
        if (newValue.selection.end >= 7) selectionIndex++;
      }
    } else {
      if (newTextLength >= 7) {
        newText.write(newValue.text.substring(2, usedSubstringIndex = 6) + '-');
        if (newValue.selection.end >= 6) selectionIndex++;
      }
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
