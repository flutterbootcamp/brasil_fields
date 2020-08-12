import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de hora ( HH:mm ).
class HoraInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (newTextLength > maxLength) {
      return oldValue;
    }

    switch (newTextLength) {
      case 1:
        final hora = int.tryParse(newValue.text.substring(0, 1));
        if (hora >= 3) return oldValue;
        break;
      case 2:
        final hora = int.tryParse(newValue.text.substring(0, 2));
        if (hora >= 24) return oldValue;
        break;
      case 3:
        final minuto = int.tryParse(newValue.text.substring(2, 3));
        if (minuto >= 6) return oldValue;
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ':');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      case 4:
        final minuto = int.tryParse(newValue.text.substring(2, 4));
        if (minuto >= 60) return oldValue;
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ':');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      default:
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
