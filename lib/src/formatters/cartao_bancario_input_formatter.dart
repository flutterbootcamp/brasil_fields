import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara `0000 1111 2222 3333`
class CartaoBancarioInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 16;

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

    if (newValueLength >= 4) {
      newText.write(newValue.text.substring(0, substrIndex = 4) + ' ');
      if (newValue.selection.end >= 5) selectionIndex++;
    }
    if (newValueLength >= 8) {
      newText.write(newValue.text.substring(4, substrIndex = 8) + ' ');
      if (newValue.selection.end >= 9) selectionIndex++;
    }
    if (newValueLength >= 12) {
      newText.write(newValue.text.substring(8, substrIndex = 12) + ' ');
      if (newValue.selection.end >= 13) selectionIndex++;
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
