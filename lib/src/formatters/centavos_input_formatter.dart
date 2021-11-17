import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a mascara ( 9.999.999.999,00 ).
///
/// `[casasDecimais]` indica a quantidade de casas usadas.
class CentavosInputFormatter extends TextInputFormatter {
  CentavosInputFormatter({this.moeda = false, this.casasDecimais = 2});

  /// Define o tamanho máximo do campo.
  int maxLength = 12;

  final bool moeda;
  final int casasDecimais;

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

    const simbolo = 'R\$ ';
    final newText = StringBuffer();
    var centsValue = "";
    var valorFinal = newValue.text;
    var numero = int.parse(newValue.text);

    var textValue = newValue.text.padLeft(
        newValue.text.length == 1 ? casasDecimais + 1 : casasDecimais, "");
    if (textValue.length >= casasDecimais) {
      centsValue = textValue.substring(
          textValue.length - casasDecimais, textValue.length);
      valorFinal = textValue.substring(0, textValue.length - casasDecimais);
    }

    // apaga o campo quando os valores foram zero.
    if (numero == 0 && int.parse(centsValue) == 0) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // retorna apenas o valor decimal, após o 0
    if (textValue.length == casasDecimais) {
      valorFinal = "0," + centsValue;
      if (moeda) {
        valorFinal = simbolo + valorFinal;
      }
      newText.write(valorFinal);

      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    // formata o número com 0, + centavos
    if (numero > 0 && numero < 9) {
      centsValue = "0" + numero.toString();
      numero = 0;
    } else if (numero >= 10 && numero < 100) {
      centsValue = numero.toString();
      numero = 0;
    } else if (valorFinal.isNotEmpty) {
      numero = int.parse(valorFinal);
    }
    if (numero > 999) {
      valorFinal = adicionarSeparador(numero.toString()) + "," + centsValue;
    } else {
      valorFinal = numero.toString() + "," + centsValue;
    }

    if (moeda) {
      valorFinal = simbolo + valorFinal;
    }
    newText.write(valorFinal);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
