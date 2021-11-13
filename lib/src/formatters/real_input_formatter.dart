import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara ( 9.999.999.999,00 ).
///
/// `[centavos]` indica se o campo deve ter centavos ou não.
/// `[quantidadeCasasDecimais]` indica a quantidade de casas usadas.
class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter(
      {this.centavos = false,
      this.moeda = false,
      this.quantidadeCasasDecimais = 2});

  /// Define o tamanho máximo do campo.
  int maxLength = 12;

  /// [centavos] para indicar se o campo aceita centavos ou não.
  final bool centavos;
  final bool moeda;
  final int quantidadeCasasDecimais;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    const simbolo = 'R\$ ';
    var substrIndex = 0;
    final newText = StringBuffer();
    var centsValue = "";
    var integerValue = newValue.text;
    var integerValueFormated = "";
    integerValue = newValue.text;
    if (centavos) {
      var textValue = newValue.text.padLeft(
          newValue.text.length == 1
              ? quantidadeCasasDecimais + 1
              : quantidadeCasasDecimais,
          "");
      if (textValue.length >= quantidadeCasasDecimais) {
        centsValue = textValue.substring(
            textValue.length - quantidadeCasasDecimais, textValue.length);
        integerValue =
            textValue.substring(0, textValue.length - quantidadeCasasDecimais);
      }
    }
    var pointCount = 0;
    for (var i = integerValue.length - 1; i > -1; i--) {
      pointCount = pointCount + 1;
      if (pointCount == 4) {
        integerValueFormated = "." + integerValueFormated;
        pointCount = 0;
      }
      integerValueFormated = integerValue[i] + integerValueFormated;
    }

    if (integerValueFormated.isEmpty) {
      integerValueFormated = "";
    } else {
      if (centavos) {
        var inteiro = int.parse(
            integerValueFormated.replaceAll(",", "").replaceAll(".", ""));

        if (inteiro < 10 && inteiro > 0 && centsValue.isEmpty) {
          centsValue = "0" + inteiro.toString();
          inteiro = 0;
        }

        integerValueFormated = centsValue.isNotEmpty
            ? inteiro.toString() + "," + centsValue
            : inteiro.toString();
      }

      if (moeda) {
        integerValueFormated = integerValueFormated.isNotEmpty
            ? simbolo + integerValueFormated
            : integerValueFormated;
      }
    }

    newText.write(integerValueFormated);
    substrIndex = integerValueFormated.length;

    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    selectionIndex = newText.length;

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
