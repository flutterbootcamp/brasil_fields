import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a máscara `999.999.999.999`.

class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter({this.moeda = false});

  final bool moeda;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 12) return oldValue;

    if (newValue.text.isEmpty) return newValue;

    final valorFinal = StringBuffer();

    if (moeda) {
      valorFinal.write('R\$ ${adicionarSeparador(newValue.text)}');
    } else {
      valorFinal.write(adicionarSeparador(newValue.text));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
