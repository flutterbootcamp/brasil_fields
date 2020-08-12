import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara MM/AA
class ValidadeCartaoInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newTextLength > maxLength) {
      return oldValue;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    switch (newTextLength) {
      case 1:
        final hora = int.tryParse(newValue.text.substring(0, 1));
        if (hora >= 2) return oldValue;
        break;
      case 2:
        final hora = int.tryParse(newValue.text.substring(0, 2));
        if (hora >= 13) return oldValue;
        break;
      case 3:
      case 4:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
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
