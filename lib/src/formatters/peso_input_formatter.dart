import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara kg,g (ex: `103,8`)
class PesoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;

    // Verifica o tamanho máximo do campo.
    if (newTextLength > 4) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    switch (newTextLength) {
      case 3:
        newText.write('${newValue.text.substring(0, substrIndex = 2)},');
        if (newValue.selection.end >= 3) selectionIndex++;
        break;
      case 4:
        newText.write('${newValue.text.substring(0, substrIndex = 3)},');
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
