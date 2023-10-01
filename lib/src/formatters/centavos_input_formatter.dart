import 'package:flutter/services.dart';

import 'adiciona_separador.dart';

/// Formata o valor do campo com a máscara `9.999.999.999,00`.
///
/// `casasDecimais` indica a quantidade de casas usadas.
class CentavosInputFormatter extends TextInputFormatter {
  CentavosInputFormatter({this.moeda = false, this.casasDecimais = 2})
      : assert(casasDecimais == 2 || casasDecimais == 3,
            'Quantidade de casas decimais deve ser 2 ou 3. Informado: $casasDecimais');

  final bool moeda;
  final int casasDecimais;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || newValue.text.length > 12) return oldValue;

    final newText = StringBuffer();
    var centavos = "";
    var textoFinal = newValue.text;
    var reais = int.parse(newValue.text);

    var textValue = newValue.text.padLeft(
        newValue.text.length == 1 ? casasDecimais + 1 : casasDecimais, "");
    if (textValue.length >= casasDecimais) {
      centavos = textValue.substring(
          textValue.length - casasDecimais, textValue.length);
      textoFinal = textValue.substring(0, textValue.length - casasDecimais);
    }
    // apaga o campo quando os valores forem zero (inteiro e decimais).
    if (reais == 0 && int.tryParse(centavos) == 0) {
      return TextEditingValue.empty;
    }

    // apaga o campo quando novo valor for 0 e o valor anterior tambem era 0.
    if (reais == 0 && (oldValue.text == '0,' || oldValue.text == 'R\$ 0,')) {
      return TextEditingValue.empty;
    }

    // retorna apenas o valor decimal, após o 0
    if (textValue.length == casasDecimais) {
      textoFinal = "0,$centavos";
      if (moeda) {
        textoFinal = 'R\$ $textoFinal';
      }
      newText.write(textoFinal);

      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    // formata o número com 0, + centavos
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

    // adiciona

    if (reais > 999) {
      textoFinal = "${adicionarSeparador(reais.toString())},$centavos";
    } else {
      textoFinal = "$reais,$centavos";
    }

    if (moeda) {
      textoFinal = 'R\$ $textoFinal';
    }
    newText.write(textoFinal);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
