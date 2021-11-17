import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a mascara ( 9.999.999.999 ).
class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter({this.moeda = false});

  /// Define o tamanho máximo do campo.
  int maxLength = 12;

  final bool moeda;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength == 0) {
      return newValue;
    }
    if (newValueLength > maxLength) {
      return oldValue;
    }

    final newText = StringBuffer();
    var valorFinal = newValue.text;

    if (moeda) {
      newText.write('R\$ ' + adicionarSeparador(valorFinal));
    } else {
      newText.write(adicionarSeparador(valorFinal));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
