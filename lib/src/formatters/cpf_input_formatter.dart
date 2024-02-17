// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';

import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';

/// Formata o valor do campo com a mascara de CPF: `XXX.XXX.XXX-XX`
class CpfInputFormatter extends TextInputFormatter implements CompoundableFormatter {
  final bool deleteSeparatorsAutomatically;
  CpfInputFormatter({this.deleteSeparatorsAutomatically = true});

  // Define o tamanho máximo do campo.
  @override
  int get maxLength => 14;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > maxLength) return oldValue;

    // valida o parâmetro que indica se deve remover os separadores automaticamente ao apagar um número
    if (newValue.text.length < oldValue.text.length) {
      if (deleteSeparatorsAutomatically == true) {
        if (newValue.text.endsWith('.') || newValue.text.endsWith('-')) {
          return newValue.copyWith(
            text: newValue.text.substring(0, newValue.text.length - 1),
            selection: TextSelection.collapsed(offset: newValue.selection.end - 1),
          );
        }
        return newValue;
      } else {
        return newValue;
      }
    }

    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length >= 4) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 3)}.');
    }
    if (newValue.text.length >= 7) {
      valorFinal.write('${newValue.text.substring(4, substrIndex = 7)}.');
    }
    if (newValue.text.length >= 11) {
      valorFinal.write('${newValue.text.substring(8, substrIndex = 11)}-');
    }
    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex).replaceAll('.', '').replaceAll('-', ''));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
