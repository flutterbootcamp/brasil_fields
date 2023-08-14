import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a máscara `9.999.999.999,00`.
///
/// `casasDecimais` indica a quantidade de casas usadas.
class CentavosInputFormatter extends TextInputFormatter {
  CentavosInputFormatter({
    this.moeda = false,
    this.casasDecimais = 2,
    this.mostrarZerado = false,
  }) : assert(casasDecimais == 2 || casasDecimais == 3,
            'Quantidade de casas decimais deve ser 2 ou 3. Informado: $casasDecimais');

  final bool moeda;
  final int casasDecimais;
  final bool mostrarZerado;

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
    if (!mostrarZerado && numero == 0 && int.tryParse(centsValue) == 0) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // retorna apenas o valor decimal, após o 0
    if (textValue.length == casasDecimais) {
      valorFinal = "0,$centsValue";
      if (moeda) {
        valorFinal = simbolo + valorFinal;
      }
      newText.write(valorFinal);

      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    final minCentsValor = mostrarZerado ? 0 : 1;

    // formata o número com 0, + centavos
    if (numero >= minCentsValor && numero <= 9) {
      if (casasDecimais == 3) {
        centsValue = "00$numero";
      } else {
        centsValue = "0$numero";
      }

      numero = 0;
    } else if (numero >= 10 && numero < 100) {
      if (casasDecimais == 3) {
        centsValue = "0$numero";
      } else {
        centsValue = numero.toString();
      }

      numero = 0;
    } else if (valorFinal.isNotEmpty) {
      numero = int.parse(valorFinal);
    }

    // adiciona

    if (numero > 999) {
      valorFinal = "${adicionarSeparador(numero.toString())},$centsValue";
    } else {
      valorFinal = "$numero,$centsValue";
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
