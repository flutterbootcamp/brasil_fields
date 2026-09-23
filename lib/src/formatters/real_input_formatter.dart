import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata um valor inteiro com separadores de milhares.
///
/// Quando [moeda] é `true`, adiciona o prefixo `R$ `.
class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter({this.moeda = false});

  final bool moeda;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

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
