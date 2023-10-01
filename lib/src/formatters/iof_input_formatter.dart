import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `1,234567`
class IOFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // verifica o tamanho máximo do campo
    if (newValueLength > 7) return oldValue;

    if (newValueLength == 0) return newValue;

    String valorFinal = newValue.text;

    if (newValueLength >= 2) {
      valorFinal =
          '${newValue.text.substring(0, 1)},${newValue.text.substring(1, newValueLength)}';
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
