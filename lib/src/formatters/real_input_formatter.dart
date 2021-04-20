import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara ( 9.999.999.999,00 ).
///
/// `[centavos]` indica se o campo deve ter centavos ou não.
class RealInputFormatter extends TextInputFormatter {
  RealInputFormatter({this.centavos = false, this.moeda = false});

  /// Define o tamanho máximo do campo.
  int maxLength = 12;

  /// [centavos] para indicar se o campo aceita centavos ou não.
  final bool centavos;
  final bool moeda;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    final currency = 'R\$ ';
    var usedSubstringIndex = 0;
    final newText = StringBuffer();
    if (moeda) {
      if (centavos) {
        maxLength = 14;
        switch (novoTextLength) {
          case 1:
            newText.write(currency + '0,0');
            selectionIndex = 7;
            break;
          case 2:
            if (valorNovo.text[0] == '0') {
              newText.write(currency +
                  '0,0' +
                  valorNovo.text.substring(1, 2) +
                  valorNovo.text.substring(2, usedSubstringIndex = 2));
              selectionIndex = 7;
            } else {
              newText.write(currency +
                  '0,' +
                  valorNovo.text.substring(0, 2) +
                  valorNovo.text.substring(2, usedSubstringIndex = 2));
              selectionIndex = 7;
            }
            break;
          case 3:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                ',' +
                valorNovo.text.substring(1, usedSubstringIndex = 2));
            selectionIndex = 7;
            break;
          case 4:
            if (valorNovo.text[0] == '0') {
              newText.write(currency +
                  valorNovo.text.substring(1, 2) +
                  ',' +
                  valorNovo.text.substring(2, usedSubstringIndex = 4));
              selectionIndex = 7;
            } else {
              newText.write(currency +
                  valorNovo.text.substring(0, 2) +
                  ',' +
                  valorNovo.text.substring(2, usedSubstringIndex = 4));
              selectionIndex = 8;
            }
            break;
          case 5:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                ',' +
                valorNovo.text.substring(3, usedSubstringIndex = 5));
            selectionIndex = 9;
            break;
          case 6:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                ',' +
                valorNovo.text.substring(4, usedSubstringIndex = 5));
            selectionIndex = 11;
            break;
          case 7:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                ',' +
                valorNovo.text.substring(5, usedSubstringIndex = 6));
            selectionIndex = 12;
            break;
          case 8:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                ',' +
                valorNovo.text.substring(6, usedSubstringIndex = 7));
            selectionIndex = 13;
            break;
          case 9:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                ',' +
                valorNovo.text.substring(7, usedSubstringIndex = 8));
            selectionIndex = 15;
            break;
          case 10:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                ',' +
                valorNovo.text.substring(8, usedSubstringIndex = 9));
            selectionIndex = 16;
            break;
          case 11:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                ',' +
                valorNovo.text.substring(9, usedSubstringIndex = 10));
            selectionIndex = 17;
            break;
          case 12:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                '.' +
                valorNovo.text.substring(7, 10) +
                ',' +
                valorNovo.text.substring(10, usedSubstringIndex = 11));
            selectionIndex = 19;
            break;
          case 13:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                '.' +
                valorNovo.text.substring(8, 11) +
                ',' +
                valorNovo.text.substring(11, usedSubstringIndex = 11));
            selectionIndex = 20;
            break;
          case 14:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                '.' +
                valorNovo.text.substring(9, 12) +
                ',' +
                valorNovo.text.substring(12, usedSubstringIndex = 13));
            selectionIndex = 21;
            break;
        }
      } else {
        switch (novoTextLength) {
          case 0:
            newText.write(currency);
            selectionIndex = 3;
            break;
          case 1:
            newText.write(currency);
            selectionIndex = 4;
            break;
          case 2:
            newText.write(currency);
            selectionIndex = 5;
            break;
          case 3:
            newText.write(currency);
            selectionIndex = 6;
            break;
          case 4:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, usedSubstringIndex = 3));
            selectionIndex = 8;
            break;
          case 5:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, usedSubstringIndex = 3));
            selectionIndex = 9;
            break;
          case 6:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, usedSubstringIndex = 3));
            selectionIndex = 10;
            break;
          case 7:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, usedSubstringIndex = 5));

            selectionIndex = 12;
            break;
          case 8:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, usedSubstringIndex = 6));
            selectionIndex = 13;
            break;
          case 9:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, usedSubstringIndex = 7));
            selectionIndex = 14;
            break;
          case 10:
            newText.write(currency +
                valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                '.' +
                valorNovo.text.substring(7, usedSubstringIndex = 10));
            selectionIndex = 16;
            break;
          case 11:
            newText.write(currency +
                valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                '.' +
                valorNovo.text.substring(8, usedSubstringIndex = 11));
            selectionIndex = 17;
            break;
          case 12:
            newText.write(currency +
                valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                '.' +
                valorNovo.text.substring(9, usedSubstringIndex = 12));
            selectionIndex = 18;
            break;
        }
      }
    } else {
      if (centavos) {
        maxLength = 14;
        switch (novoTextLength) {
          case 1:
            newText.write('0,0');
            selectionIndex = 4;
            break;
          case 2:
            if (valorNovo.text[0] == '0') {
              newText.write('0,0' +
                  valorNovo.text.substring(1, 2) +
                  valorNovo.text.substring(2, usedSubstringIndex = 2));
              selectionIndex = 4;
            } else {
              newText.write('0,' +
                  valorNovo.text.substring(0, 2) +
                  valorNovo.text.substring(2, usedSubstringIndex = 2));
              selectionIndex = 4;
            }
            break;
          case 3:
            newText.write(valorNovo.text.substring(0, 1) +
                ',' +
                valorNovo.text.substring(1, usedSubstringIndex = 2));
            selectionIndex = 4;
            break;
          case 4:
            if (valorNovo.text[0] == '0') {
              newText.write(valorNovo.text.substring(1, 2) +
                  ',' +
                  valorNovo.text.substring(2, usedSubstringIndex = 4));
              selectionIndex = 4;
            } else {
              newText.write(valorNovo.text.substring(0, 2) +
                  ',' +
                  valorNovo.text.substring(2, usedSubstringIndex = 4));
              selectionIndex = 5;
            }
            break;
          case 5:
            newText.write(valorNovo.text.substring(0, 3) +
                ',' +
                valorNovo.text.substring(3, usedSubstringIndex = 5));
            selectionIndex = 6;
            break;
          case 6:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                ',' +
                valorNovo.text.substring(4, usedSubstringIndex = 5));
            selectionIndex = 8;
            break;
          case 7:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                ',' +
                valorNovo.text.substring(5, usedSubstringIndex = 6));
            selectionIndex = 9;
            break;
          case 8:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                ',' +
                valorNovo.text.substring(6, usedSubstringIndex = 7));
            selectionIndex = 10;
            break;
          case 9:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                ',' +
                valorNovo.text.substring(7, usedSubstringIndex = 8));
            selectionIndex = 12;
            break;
          case 10:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                ',' +
                valorNovo.text.substring(8, usedSubstringIndex = 9));
            selectionIndex = 13;
            break;
          case 11:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                ',' +
                valorNovo.text.substring(9, usedSubstringIndex = 10));
            selectionIndex = 14;
            break;
          case 12:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                '.' +
                valorNovo.text.substring(7, 10) +
                ',' +
                valorNovo.text.substring(10, usedSubstringIndex = 11));
            selectionIndex = 16;
            break;
          case 13:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                '.' +
                valorNovo.text.substring(8, 11) +
                ',' +
                valorNovo.text.substring(11, usedSubstringIndex = 11));
            selectionIndex = 17;
            break;
          case 14:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                '.' +
                valorNovo.text.substring(9, 12) +
                ',' +
                valorNovo.text.substring(12, usedSubstringIndex = 13));
            selectionIndex = 18;
            break;
        }
      } else {
        switch (novoTextLength) {
          case 4:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, usedSubstringIndex = 3));
            selectionIndex = 5;

            break;
          case 5:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, usedSubstringIndex = 3));
            selectionIndex = 6;
            break;
          case 6:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, usedSubstringIndex = 3));
            selectionIndex = 7;
            break;
          case 7:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, usedSubstringIndex = 5));

            selectionIndex = 9;
            break;
          case 8:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, usedSubstringIndex = 6));
            selectionIndex = 10;
            break;
          case 9:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, usedSubstringIndex = 7));
            selectionIndex = 11;
            break;
          case 10:
            newText.write(valorNovo.text.substring(0, 1) +
                '.' +
                valorNovo.text.substring(1, 4) +
                '.' +
                valorNovo.text.substring(4, 7) +
                '.' +
                valorNovo.text.substring(7, usedSubstringIndex = 10));
            selectionIndex = 13;
            break;
          case 11:
            newText.write(valorNovo.text.substring(0, 2) +
                '.' +
                valorNovo.text.substring(2, 5) +
                '.' +
                valorNovo.text.substring(5, 8) +
                '.' +
                valorNovo.text.substring(8, usedSubstringIndex = 11));
            selectionIndex = 14;
            break;
          case 12:
            newText.write(valorNovo.text.substring(0, 3) +
                '.' +
                valorNovo.text.substring(3, 6) +
                '.' +
                valorNovo.text.substring(6, 9) +
                '.' +
                valorNovo.text.substring(9, usedSubstringIndex = 12));
            selectionIndex = 15;
            break;
        }
      }
    }

    if (novoTextLength >= usedSubstringIndex) {
      newText.write(valorNovo.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
