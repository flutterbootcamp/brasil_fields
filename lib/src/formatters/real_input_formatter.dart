import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a máscara `999.999.999.999`.

class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter({this.moeda = false});

  final bool moeda;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    // Verifica o tamanho máximo do campo.
    if (newValueLength > 12) {
      return oldValue;
    }

    if (newValueLength == 0) {
      return newValue;
    }

    final newText = StringBuffer();
    var valorFinal = newValue.text;

    if (moeda) {
      newText.write('R\$ ${adicionarSeparador(valorFinal)}');
    } else {
      newText.write(adicionarSeparador(valorFinal));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
