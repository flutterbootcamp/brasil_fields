import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara kg,g (ex: 103,8)
class PesoInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newTextLength > maxLength) {
      return oldValue;
    }

    switch (newTextLength) {
      case 3:
        newText.write(newValue.text.substring(0, substrIndex = 2) + ',');
        if (newValue.selection.end >= 3) selectionIndex++;
        break;
      case 4:
        newText.write(newValue.text.substring(0, substrIndex = 3) + ',');
        if (newValue.selection.end >= 4) selectionIndex++;
        break;
    }

    if (newTextLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
