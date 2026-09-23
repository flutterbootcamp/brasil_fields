import 'package:flutter/services.dart';

/// Formata um valor de IOF com até seis casas decimais (por exemplo, `1,234567`).
class IOFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    final newValueLength = newValue.text.length;

    if (newValueLength > 7) return oldValue;

    if (newValueLength == 0) return newValue;

    String valorFinal = newValue.text;

    if (newValueLength >= 2) {
      valorFinal =
          '${newValue.text.substring(0, 1)},${newValue.text.substring(1, newValueLength)}';
    }

    return TextEditingValue(
      text: valorFinal,
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
