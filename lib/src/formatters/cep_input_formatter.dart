import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CEP `XX.XXX-XXX`
///
/// `ponto` indica se o formato do CEP deve utilizar `.` ou não.
class CepInputFormatter extends TextInputFormatter {
  final bool ponto;

  CepInputFormatter({this.ponto = true});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // Define o tamanho máximo do campo.
    if (newValueLength > 8) {
      return oldValue;
    }
    var substrInicio = 2;
    if (!ponto) {
      substrInicio = 0;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength >= 3 && ponto) {
      newText.write(newValue.text.substring(0, substrIndex = 2) + '.');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newValueLength >= 6) {
      newText
          .write(newValue.text.substring(substrInicio, substrIndex = 5) + '-');
      if (newValue.selection.end >= 5) selectionIndex++;
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
