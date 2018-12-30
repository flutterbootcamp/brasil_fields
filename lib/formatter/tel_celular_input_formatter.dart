import 'package:brasil_fields/formatter/max_length_input_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara ( (61) 9999-9999 )
class TelCelularInputFormatter extends TextInputFormatter
    with MaxLengthInputFormatter {
  final int maxLength = 11;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ') ');
      if (newValue.selection.end >= 2) {
        selectionIndex += 2;
      }
    }
    if (newTextLength >= 8) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 7) + '-');
      if (newValue.selection.end >= 7) {
        selectionIndex++;
      }
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
