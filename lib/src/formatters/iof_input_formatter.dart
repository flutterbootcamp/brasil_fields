import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `9,99999`.

class IOFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // Verifica o tamanho máximo do campo.
    if (newValueLength > 7) {
      return oldValue;
    }

    if (newValueLength == 0) {
      return newValue;
    }

    final newText = StringBuffer();

    if (newValueLength >= 2) {
      newText.write(
          '${newValue.text.substring(0, 1)},${newValue.text.substring(1, newValueLength)}');
    } else {
      newText.write(newValue.text);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
