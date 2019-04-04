import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara ( (99) 9999-9999 ).
///
/// `[digito_9]` indica se o campo tera o nono dígito ou não.
class TelefoneInputFormatter extends TextInputFormatter {
  TelefoneInputFormatter({this.digito_9 = false});

  /// Define o tamanho máximo do campo.
  int maxLength = 10;

  /// [boolean] para indicar se o campo aceita o nono dígito ou não.
  bool digito_9;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    // Altera o tamanho máximo do campo baseado em [digito_9]
    if (digito_9) {
      maxLength = 11;
    }
    if (newTextLength > maxLength) {
      return oldValue;
    }

    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }

    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ') ');
      if (newValue.selection.end >= 2) {
        selectionIndex += 2;
      }
    }
    if (digito_9) {
      if (newTextLength >= 8) {
        newText.write(newValue.text.substring(2, usedSubstringIndex = 7) + '-');
        if (newValue.selection.end >= 7) {
          selectionIndex++;
        }
      }
    } else {
      if (newTextLength >= 7) {
        newText.write(newValue.text.substring(2, usedSubstringIndex = 6) + '-');
        if (newValue.selection.end >= 6) {
          selectionIndex++;
        }
      }
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
