import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de hora ( HH:mm ).
class HoraInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    switch (novoTextLength) {
      case 1:
        final hora = int.tryParse(valorNovo.text.substring(0, 1));
        if (hora != null) {
          if (hora >= 3) return valorAntigo;
        }
        break;
      case 2:
        final hora = int.tryParse(valorNovo.text.substring(0, 2));
        if (hora != null) {
          if (hora >= 24) return valorAntigo;
        }
        break;
      case 3:
        final minuto = int.tryParse(valorNovo.text.substring(2, 3));
        if (minuto != null) {
          if (minuto >= 6) return valorAntigo;
        }
        newText.write(valorNovo.text.substring(0, usedSubstringIndex = 2) + ':');
        if (valorNovo.selection.end >= 2) selectionIndex++;
        break;
      case 4:
        final minuto = int.tryParse(valorNovo.text.substring(2, 4));
        if (minuto != null) {
          if (minuto >= 60) return valorAntigo;
        }
        newText.write(valorNovo.text.substring(0, usedSubstringIndex = 2) + ':');
        if (valorNovo.selection.end >= 2) selectionIndex++;
        break;
      default:
    }

    if (novoTextLength >= usedSubstringIndex) {
      newText.write(valorNovo.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
