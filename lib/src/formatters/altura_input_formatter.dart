import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara m,cm. (`1,82`)
class AlturaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 3) return oldValue;

    // evita que o primeiro digito seja > 2
    if (newValue.text.isNotEmpty) {
      final primeiroDigito = int.tryParse(newValue.text[0]);
      if (primeiroDigito == null || primeiroDigito > 2) {
        return oldValue;
      }
    }

    String valorFinal = newValue.text;

    // adiciona ","
    if (newValue.text.length == 3) {
      valorFinal = '${newValue.text[0]},${newValue.text[1]}${newValue.text[2]}';
    } else if (newValue.text.length == 2) {
      valorFinal = '${newValue.text[0]},${newValue.text[1]}';
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
