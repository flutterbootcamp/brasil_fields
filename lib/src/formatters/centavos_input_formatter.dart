import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo como um número decimal no padrão brasileiro.
///
/// [casasDecimais] aceita `2` ou `3`. Quando [moeda] é `true`, adiciona o
/// prefixo `R$ `.
class CentavosInputFormatter extends TextInputFormatter {
  CentavosInputFormatter({this.moeda = false, this.casasDecimais = 2})
      : assert(casasDecimais == 2 || casasDecimais == 3,
            'Quantidade de casas decimais deve ser 2 ou 3. Informado: $casasDecimais');

  final bool moeda;
  final int casasDecimais;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;
    if (newValue.text.isEmpty) return newValue;
    if (newValue.text.length > 12) return oldValue;

    final valorFinal = StringBuffer();
    var centavos = "";
    var textoFinal = newValue.text;
    var reais = int.parse(newValue.text);

    final textValue = newValue.text.padLeft(
        newValue.text.length == 1 ? casasDecimais + 1 : casasDecimais, "");
    if (textValue.length >= casasDecimais) {
      centavos = textValue.substring(
          textValue.length - casasDecimais, textValue.length);
      textoFinal = textValue.substring(0, textValue.length - casasDecimais);
    }
    // Mantém o campo vazio enquanto todos os dígitos são zero.
    if (reais == 0 && int.tryParse(centavos) == 0) {
      return TextEditingValue.empty;
    }

    // Permite apagar o último zero de um valor já formatado.
    if (reais == 0 && (oldValue.text == '0,' || oldValue.text == 'R\$ 0,')) {
      return TextEditingValue.empty;
    }

    // Acrescenta a parte inteira zero quando ainda só há casas decimais.
    if (textValue.length == casasDecimais) {
      textoFinal = "0,$centavos";
      if (moeda) {
        textoFinal = 'R\$ $textoFinal';
      }
      valorFinal.write(textoFinal);

      return TextEditingValue(
        text: valorFinal.toString(),
        selection: TextSelection.collapsed(offset: valorFinal.length),
      );
    }

    // Distribui os primeiros dígitos entre as partes inteira e decimal.
    if (reais > 0 && reais <= 9) {
      if (casasDecimais == 3) {
        centavos = "00$reais";
      } else {
        centavos = "0$reais";
      }

      reais = 0;
    } else if (reais >= 10 && reais < 100) {
      if (casasDecimais == 3) {
        centavos = "0$reais";
      } else {
        centavos = reais.toString();
      }

      reais = 0;
    } else if (textoFinal.isNotEmpty) {
      reais = int.parse(textoFinal);
    }

    if (reais > 999) {
      textoFinal = "${adicionarSeparador(reais.toString())},$centavos";
    } else {
      textoFinal = "$reais,$centavos";
    }

    if (moeda) {
      textoFinal = 'R\$ $textoFinal';
    }
    valorFinal.write(textoFinal);

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: valorFinal.length),
    );
  }
}
