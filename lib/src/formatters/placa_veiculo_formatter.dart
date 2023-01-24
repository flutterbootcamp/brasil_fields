import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de veículos `XXX-XXXX`.
///
///Não se deve utilizar o `FilteringTextInputFormatter.digitsOnly` com
///este formatter.
class PlacaVeiculoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    // Verifica o tamanho máximo do campo.
    if (newValueLength > 8) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength == 4) {
      if (newValue.text.contains("-")) {
        newText.write(newValue.text.substring(0, substrIndex = 3));
      } else {
        newText.write(newValue.text.substring(0, substrIndex = 3) +
            '-' +
            newValue.text.substring(3, substrIndex = newValueLength));
        selectionIndex++;
      }
    }

    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString().toUpperCase(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
