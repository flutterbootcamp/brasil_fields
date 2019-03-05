import 'package:brasil_fields/formatter/max_length_input_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CPF ( 99.999.999/9999-99 )
class CnpjInputFormatter extends TextInputFormatter
    with MaxLengthInputFormatter {
  final int maxLength = 14;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '.');
      if (newValue.selection.end >= 2) {
        selectionIndex++;
      }
    }
    if (newTextLength >= 6) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 5) + '.');
      if (newValue.selection.end >= 5) {
        selectionIndex++;
      }
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(5, usedSubstringIndex = 8) + '/');
      if (newValue.selection.end >= 8) {
        selectionIndex++;
      }
    }
    if (newTextLength >= 13) {
      newText.write(newValue.text.substring(8, usedSubstringIndex = 12) + '-');
      if (newValue.selection.end >= 12) {
        selectionIndex++;
      }
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
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
