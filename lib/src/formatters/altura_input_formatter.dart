import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara m,cm. `1,82`
class AlturaInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 3;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    if (newValueLength > 0) {
      final numNovo = int.tryParse(newValue.text.substring(0, 1));
      if (numNovo != null) {
        if (numNovo > 2) {
          return oldValue;
        }
      }
    }

    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength > 2) {
      newText.write(newValue.text.substring(0, substrIndex = 1) + ',');
      if (newValue.selection.end > 2) selectionIndex++;
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
