import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara `MM/AA` ou `MM/AAAA`.
///
/// Use [maxLength] igual a `4` para `MM/AA` ou `6` para `MM/AAAA`.
class ValidadeCartaoInputFormatter extends TextInputFormatter {
  final int maxLength;

  ValidadeCartaoInputFormatter({this.maxLength = 4})
      : assert(maxLength == 4 || maxLength == 6,
            'Tamanho do campo deve ser 4 ou 6. Informado: $maxLength');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

    final newValueLength = newValue.text.length;

    if (newValueLength > maxLength) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValueLength >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}/');
      if (newValue.selection.end >= 2) posicaoCursor++;
    }

    if (newValueLength >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
