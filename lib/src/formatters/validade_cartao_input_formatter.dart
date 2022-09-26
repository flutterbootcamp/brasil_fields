import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara MM/AA
class ValidadeCartaoInputFormatter extends TextInputFormatter {
  /// [maxLength] Define o tamanho máximo do campo e indica se o formato da máscara deve utilizar o ano com 2 ou 4 dígitos.
  final int maxLength;

  ValidadeCartaoInputFormatter({this.maxLength = 4})
      : assert(maxLength == 4 || maxLength == 6,
            'Tamanho do campo deve ser 4 ou 6. Informado: $maxLength');

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

    if (newValueLength >= 3) {
      newText.write(newValue.text.substring(0, substrIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
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
