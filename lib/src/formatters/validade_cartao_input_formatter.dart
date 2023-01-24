import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `MM/AA` ou `MM/AAAA`.
///
///  `maxLength = 4` MM/AA (default)
///
/// `maxLength = 6` MM/AAAAA.
class ValidadeCartaoInputFormatter extends TextInputFormatter {
  final int maxLength;

  ValidadeCartaoInputFormatter({this.maxLength = 4})
      : assert(maxLength == 4 || maxLength == 6,
            'Tamanho do campo deve ser 4 ou 6. Informado: $maxLength');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
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
