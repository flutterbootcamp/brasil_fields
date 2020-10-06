import 'package:flutter/services.dart';

class KmInputFormatter extends TextInputFormatter {
  final int maxLength = 6;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newTextLength > maxLength) {
      return oldValue;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();
    switch (newTextLength) {
      case 4:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 1) +
            '.' +
            newValue.text.substring(1, usedSubstringIndex = 3));
        selectionIndex += 1;
        break;
      case 5:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) +
            '.' +
            newValue.text.substring(2, usedSubstringIndex = 4));
        selectionIndex += 1;
        break;
      case 6:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 3) +
            '.' +
            newValue.text.substring(3, usedSubstringIndex = 5));
        selectionIndex += 1;
        break;
      default:
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(),
    );
  }
}

// import 'package:flutter/services.dart';

// /// Formata o valor do campo com a mascara de medida ( XX.XXX-XXX ).
// class KmInputFormatter extends TextInputFormatter {
//   /// Define o tamanho máximo do campo.
//   final int maxLength = 6;

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final newTextLength = newValue.text.length;
//     var selectionIndex = newValue.selection.end;

//     if (newTextLength > maxLength) {
//       return oldValue;
//     }

//     var usedSubstringIndex = 0;
//     final newText = StringBuffer();

//     if (newTextLength <= 4) {
//       newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ',');
//       if (newValue.selection.end >= 2) selectionIndex++;
//     } else {
//       newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ',');
//       if (newValue.selection.end >= 5) selectionIndex++;
//     }

//     if (newTextLength >= usedSubstringIndex) {
//       newText.write(newValue.text.substring(usedSubstringIndex));
//     }

//     return TextEditingValue(
//       text: newText.toString(),
//       selection: TextSelection.collapsed(offset: selectionIndex),
//     );
//   }
// }
