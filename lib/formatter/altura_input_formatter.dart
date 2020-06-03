import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara m,cm (ex: 1,82)
class AlturaInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 3;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newTextLength > maxLength) {
      return oldValue;
    }

    if (newTextLength > 0) {
      if (int.tryParse(newValue.text.substring(0, 1)) > 2) {
        return oldValue;
      }
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (newTextLength > 2) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 1) + ',');
      if (newValue.selection.end > 2) selectionIndex++;
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
