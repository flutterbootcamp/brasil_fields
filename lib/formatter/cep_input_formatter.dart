import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CEP ( XX.XXX-XXX )
class CepInputFormatter extends TextInputFormatter {
  final int maxLength = 8;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    if (newTextLength > maxLength) {
      return oldValue;
    }

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '.');
      if (newValue.selection.end >= 2) selectionIndex += 1;
    }
    if (newTextLength >= 6) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 5) + '-');
      if (newValue.selection.end >= 5) selectionIndex++;
    }
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
