import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de hora ( 000.000 ).
class KmInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 6;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    var substrIndex = 0;
    final newText = StringBuffer();
    switch (newValueLength) {
      case 4:
        newText.write(newValue.text.substring(0, substrIndex = 1) +
            '.' +
            newValue.text.substring(1, substrIndex = 3));
        selectionIndex += 1;
        break;
      case 5:
        newText.write(newValue.text.substring(0, substrIndex = 2) +
            '.' +
            newValue.text.substring(2, substrIndex = 4));
        selectionIndex += 1;
        break;
      case 6:
        newText.write(newValue.text.substring(0, substrIndex = 3) +
            '.' +
            newValue.text.substring(3, substrIndex = 5));
        selectionIndex += 1;
        break;
      default:
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
