import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de NCM: `XXXX.XX.XX`
class NCMInputFormatter extends TextInputFormatter
    implements CompoundableFormatter {
  @override
  int get maxLength => 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength > maxLength) {
      return oldValue;
    }

    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    if (newValueLength >= 5) {
      newText.write('${newValue.text.substring(0, substrIndex = 4)}.');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newValueLength >= 7) {
      newText.write('${newValue.text.substring(4, substrIndex = 6)}.');
      if (newValue.selection.end >= 6) selectionIndex++;
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
