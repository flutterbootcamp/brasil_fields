import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CNPJ ( 99.999.999/9999-99 ).
class CnpjInputFormatter extends TextInputFormatter
    implements CompoundableFormatter {
  /// Define o tamanho máximo do campo.
  @override
  int get maxLength => 14;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength >= 3) {
      newText.write(valorNovo.text.substring(0, usedSubstringIndex = 2) + '.');
      if (valorNovo.selection.end >= 2) selectionIndex++;
    }
    if (novoTextLength >= 6) {
      newText.write(valorNovo.text.substring(2, usedSubstringIndex = 5) + '.');
      if (valorNovo.selection.end >= 5) selectionIndex++;
    }
    if (novoTextLength >= 9) {
      newText.write(valorNovo.text.substring(5, usedSubstringIndex = 8) + '/');
      if (valorNovo.selection.end >= 8) selectionIndex++;
    }
    if (novoTextLength >= 13) {
      newText.write(valorNovo.text.substring(8, usedSubstringIndex = 12) + '-');
      if (valorNovo.selection.end >= 12) selectionIndex++;
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
