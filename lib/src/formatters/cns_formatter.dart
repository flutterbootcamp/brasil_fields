import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `000 1111 2222 3333`.
class CNSInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // Verifica o tamanho máximo do campo.
    if (newValueLength > 15) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength >= 3) {
      newText.write('${newValue.text.substring(0, substrIndex = 3)} ');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newValueLength >= 7) {
      newText.write('${newValue.text.substring(3, substrIndex = 7)} ');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (newValueLength >= 11) {
      newText.write('${newValue.text.substring(7, substrIndex = 11)} ');
      if (newValue.selection.end >= 12) selectionIndex++;
    }
    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
