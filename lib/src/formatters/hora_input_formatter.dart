import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de hora `HH:mm`
class HoraInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // Verifica o tamanho máximo do campo.
    if (newValueLength > 4) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    switch (newValueLength) {
      case 1:
        final hora = int.parse(newValue.text.substring(0, 1));
        if (hora >= 3) return oldValue;
        break;
      case 2:
        final hora = int.parse(newValue.text.substring(0, 2));
        if (hora >= 24) return oldValue;
        break;
      case 3:
        final minuto = int.parse(newValue.text.substring(2, 3));
        if (minuto >= 6) return oldValue;
        newText.write('${newValue.text.substring(0, substrIndex = 2)}:');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      case 4:
        final minuto = int.parse(newValue.text.substring(2, 4));
        if (minuto >= 60) return oldValue;
        newText.write('${newValue.text.substring(0, substrIndex = 2)}:');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
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
