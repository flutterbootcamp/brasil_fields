import 'package:brasil_fields/formatter/max_length_input_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de data ( 01/01/1900 )
class DataFormatter extends TextInputFormatter with MaxLengthInputFormatter {
  final int maxLength = 8;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 5) + '/');
      if (newValue.selection.end >= 5) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    if (maxLength != null &&
        maxLength > 0 &&
        newValue.text.runes.length > maxLength) {
      return truncateLength(maxLength, newValue);
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
