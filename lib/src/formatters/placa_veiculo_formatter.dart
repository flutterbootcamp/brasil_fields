import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de veículos `XXX-XXXX`.
///
/// Não se deve utilizar o `FilteringTextInputFormatter.digitsOnly` com
/// este formatter.
class PlacaVeiculoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // verifica o tamanho máximo do campo (7 caracteres alfanuméricos + 1 traço)
    if (newValue.text.replaceAll('-', '').length > 7) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.length > 3) {
      if (newValue.text.contains("-")) {
        valorFinal.write(newValue.text.substring(0, substrIndex = 3));
      } else {
        valorFinal.write(
          '${newValue.text.substring(0, substrIndex = 3)}-${newValue.text.substring(3, substrIndex = newValue.text.length)}',
        );
        posicaoCursor++;
      }
    }

    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString().toUpperCase(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
