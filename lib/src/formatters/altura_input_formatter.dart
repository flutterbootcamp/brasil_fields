import 'package:flutter/services.dart';

/// Formata uma altura em metros com até duas casas decimais (por exemplo, `1,82`).
class AlturaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    if (newValue.text.length > 3) return oldValue;

    // Limita a altura a 2,99 m.
    if (newValue.text.isNotEmpty) {
      final primeiroDigito = int.tryParse(newValue.text[0]);
      if (primeiroDigito == null || primeiroDigito > 2) {
        return oldValue;
      }
    }

    String valorFinal = newValue.text;

    if (newValue.text.length == 3) {
      valorFinal = '${newValue.text[0]},${newValue.text[1]}${newValue.text[2]}';
    } else if (newValue.text.length == 2) {
      valorFinal = '${newValue.text[0]},${newValue.text[1]}';
    }

    return TextEditingValue(
      text: valorFinal,
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
