import '../interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de CNPJ `XX.XXX.XXX/XXXX-XX`.
///
/// Deve ser usado num TextInput que recebe letras e números:
/// ```dart
/// TextField(
///  inputFormatters: [
///    FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
///    CnpjAlfanumericoInputFormatter(),
///  ],
/// ),
/// ```
class CnpjAlfanumericoInputFormatter extends TextInputFormatter
    implements CompoundableFormatter {
  // Define o tamanho máximo do campo.
  @override
  int get maxLength => 14;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength > maxLength) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValueLength >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}.');
      if (newValue.selection.end >= 2) posicaoCursor++;
    }
    if (newValueLength >= 6) {
      valorFinal.write('${newValue.text.substring(2, substrIndex = 5)}.');
      if (newValue.selection.end >= 5) posicaoCursor++;
    }
    if (newValueLength >= 9) {
      valorFinal.write('${newValue.text.substring(5, substrIndex = 8)}/');
      if (newValue.selection.end >= 8) posicaoCursor++;
    }
    if (newValueLength >= 13) {
      valorFinal.write('${newValue.text.substring(8, substrIndex = 12)}-');
      if (newValue.selection.end >= 12) posicaoCursor++;
    }
    if (newValueLength >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString().toUpperCase(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
