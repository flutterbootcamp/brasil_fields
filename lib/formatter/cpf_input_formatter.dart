import 'package:brasil_fields/formatter/max_length_input_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CPF ( XXX.XXX.XXX-XX )
class CpfInputFormatter extends TextInputFormatter
    with MaxLengthInputFormatter {
  final int maxLength = 11;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '.');
      if (newValue.selection.end >= 3) selectionIndex += 1;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '.');
      if (newValue.selection.end >= 6) selectionIndex += 1;
    }
    if (newTextLength >= 10) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 9) + '-');
      if (newValue.selection.end >= 9) selectionIndex += 1;
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
