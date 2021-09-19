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
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    const currency = 'R\$ ';
    var substrIndex = 0;
    final newText = StringBuffer();
    if (moeda) {
      if (centavos) {
        maxLength = 14;
        switch (newValueLength) {
          case 1:
            newText.write(currency + '0,0');
            selectionIndex = 7;
            break;
          case 2:
            if (newValue.text[0] == '0') {
              newText.write(currency +
                  '0,0' +
                  newValue.text.substring(1, 2) +
                  newValue.text.substring(2, substrIndex = 2));
              selectionIndex = 7;
            } else {
              newText.write(currency +
                  '0,' +
                  newValue.text.substring(0, 2) +
                  newValue.text.substring(2, substrIndex = 2));
              selectionIndex = 7;
            }
            break;
          case 3:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                ',' +
                newValue.text.substring(1, substrIndex = 2));
            selectionIndex = 7;
            break;
          case 4:
            if (newValue.text[0] == '0') {
              newText.write(currency +
                  newValue.text.substring(1, 2) +
                  ',' +
                  newValue.text.substring(2, substrIndex = 4));
              selectionIndex = 7;
            } else {
              newText.write(currency +
                  newValue.text.substring(0, 2) +
                  ',' +
                  newValue.text.substring(2, substrIndex = 4));
              selectionIndex = 8;
            }
            break;
          case 5:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                ',' +
                newValue.text.substring(3, substrIndex = 5));
            selectionIndex = 9;
            break;
          case 6:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                ',' +
                newValue.text.substring(4, substrIndex = 5));
            selectionIndex = 11;
            break;
          case 7:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                ',' +
                newValue.text.substring(5, substrIndex = 6));
            selectionIndex = 12;
            break;
          case 8:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                ',' +
                newValue.text.substring(6, substrIndex = 7));
            selectionIndex = 13;
            break;
          case 9:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                ',' +
                newValue.text.substring(7, substrIndex = 8));
            selectionIndex = 15;
            break;
          case 10:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                ',' +
                newValue.text.substring(8, substrIndex = 9));
            selectionIndex = 16;
            break;
          case 11:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                ',' +
                newValue.text.substring(9, substrIndex = 10));
            selectionIndex = 17;
            break;
          case 12:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                '.' +
                newValue.text.substring(7, 10) +
                ',' +
                newValue.text.substring(10, substrIndex = 11));
            selectionIndex = 19;
            break;
          case 13:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                '.' +
                newValue.text.substring(8, 11) +
                ',' +
                newValue.text.substring(11, substrIndex = 11));
            selectionIndex = 20;
            break;
          case 14:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                '.' +
                newValue.text.substring(9, 12) +
                ',' +
                newValue.text.substring(12, substrIndex = 13));
            selectionIndex = 21;
            break;
        }
      } else {
        switch (newValueLength) {
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
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, substrIndex = 3));
            selectionIndex = 8;
            break;
          case 5:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, substrIndex = 3));
            selectionIndex = 9;
            break;
          case 6:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, substrIndex = 3));
            selectionIndex = 10;
            break;
          case 7:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, substrIndex = 5));

            selectionIndex = 12;
            break;
          case 8:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, substrIndex = 6));
            selectionIndex = 13;
            break;
          case 9:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, substrIndex = 7));
            selectionIndex = 14;
            break;
          case 10:
            newText.write(currency +
                newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                '.' +
                newValue.text.substring(7, substrIndex = 10));
            selectionIndex = 16;
            break;
          case 11:
            newText.write(currency +
                newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                '.' +
                newValue.text.substring(8, substrIndex = 11));
            selectionIndex = 17;
            break;
          case 12:
            newText.write(currency +
                newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                '.' +
                newValue.text.substring(9, substrIndex = 12));
            selectionIndex = 18;
            break;
        }
      }
    } else {
      if (centavos) {
        maxLength = 14;
        switch (newValueLength) {
          case 1:
            newText.write('0,0');
            selectionIndex = 4;
            break;
          case 2:
            if (newValue.text[0] == '0') {
              newText.write('0,0' +
                  newValue.text.substring(1, 2) +
                  newValue.text.substring(2, substrIndex = 2));
              selectionIndex = 4;
            } else {
              newText.write('0,' +
                  newValue.text.substring(0, 2) +
                  newValue.text.substring(2, substrIndex = 2));
              selectionIndex = 4;
            }
            break;
          case 3:
            newText.write(newValue.text.substring(0, 1) +
                ',' +
                newValue.text.substring(1, substrIndex = 2));
            selectionIndex = 4;
            break;
          case 4:
            if (newValue.text[0] == '0') {
              newText.write(newValue.text.substring(1, 2) +
                  ',' +
                  newValue.text.substring(2, substrIndex = 4));
              selectionIndex = 4;
            } else {
              newText.write(newValue.text.substring(0, 2) +
                  ',' +
                  newValue.text.substring(2, substrIndex = 4));
              selectionIndex = 5;
            }
            break;
          case 5:
            newText.write(newValue.text.substring(0, 3) +
                ',' +
                newValue.text.substring(3, substrIndex = 5));
            selectionIndex = 6;
            break;
          case 6:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                ',' +
                newValue.text.substring(4, substrIndex = 5));
            selectionIndex = 8;
            break;
          case 7:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                ',' +
                newValue.text.substring(5, substrIndex = 6));
            selectionIndex = 9;
            break;
          case 8:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                ',' +
                newValue.text.substring(6, substrIndex = 7));
            selectionIndex = 10;
            break;
          case 9:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                ',' +
                newValue.text.substring(7, substrIndex = 8));
            selectionIndex = 12;
            break;
          case 10:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                ',' +
                newValue.text.substring(8, substrIndex = 9));
            selectionIndex = 13;
            break;
          case 11:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                ',' +
                newValue.text.substring(9, substrIndex = 10));
            selectionIndex = 14;
            break;
          case 12:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                '.' +
                newValue.text.substring(7, 10) +
                ',' +
                newValue.text.substring(10, substrIndex = 11));
            selectionIndex = 16;
            break;
          case 13:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                '.' +
                newValue.text.substring(8, 11) +
                ',' +
                newValue.text.substring(11, substrIndex = 11));
            selectionIndex = 17;
            break;
          case 14:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                '.' +
                newValue.text.substring(9, 12) +
                ',' +
                newValue.text.substring(12, substrIndex = 13));
            selectionIndex = 18;
            break;
        }
      } else {
        switch (newValueLength) {
          case 4:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, substrIndex = 3));
            selectionIndex = 5;

            break;
          case 5:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, substrIndex = 3));
            selectionIndex = 6;
            break;
          case 6:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, substrIndex = 3));
            selectionIndex = 7;
            break;
          case 7:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, substrIndex = 5));

            selectionIndex = 9;
            break;
          case 8:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, substrIndex = 6));
            selectionIndex = 10;
            break;
          case 9:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, substrIndex = 7));
            selectionIndex = 11;
            break;
          case 10:
            newText.write(newValue.text.substring(0, 1) +
                '.' +
                newValue.text.substring(1, 4) +
                '.' +
                newValue.text.substring(4, 7) +
                '.' +
                newValue.text.substring(7, substrIndex = 10));
            selectionIndex = 13;
            break;
          case 11:
            newText.write(newValue.text.substring(0, 2) +
                '.' +
                newValue.text.substring(2, 5) +
                '.' +
                newValue.text.substring(5, 8) +
                '.' +
                newValue.text.substring(8, substrIndex = 11));
            selectionIndex = 14;
            break;
          case 12:
            newText.write(newValue.text.substring(0, 3) +
                '.' +
                newValue.text.substring(3, 6) +
                '.' +
                newValue.text.substring(6, 9) +
                '.' +
                newValue.text.substring(9, substrIndex = 12));
            selectionIndex = 15;
            break;
        }
      }
    }

    if (newValueLength >= substrIndex) {
      newText.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
