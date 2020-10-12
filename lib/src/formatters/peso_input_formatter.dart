import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara kg,g (ex: 103,8)
class PesoInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  PesoInputFormatter();

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
      case 3:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ',');
        if (newValue.selection.end >= 3) selectionIndex++;
        break;
      case 4:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ',');
        if (newValue.selection.end >= 4) selectionIndex++;
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
