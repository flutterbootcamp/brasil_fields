import 'package:flutter/services.dart';

/// Formata o valor do campo com a máscara de hora `HH:mm`
///
/// Nao aceita [hora > 24] e [minuto > 59]
class HoraInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 4) return oldValue;

    var posicaoCursor = newValue.selection.end;
    var substrIndex = 0;
    final valorFinal = StringBuffer();

    obterHora() => int.parse(newValue.text[0] + newValue.text[1]);

    switch (newValue.text.length) {
      case 1:
        final hora = int.parse(newValue.text[0]);
        if (hora >= 3) return oldValue;
        break;
      case 2:
        if (obterHora() >= 24) return oldValue;
        break;
      case 3:
        if (obterHora() >= 24) return oldValue;
        final minuto = int.parse(newValue.text[2]);
        if (minuto >= 6) return oldValue;
        valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}:');
        if (newValue.selection.end >= 2) posicaoCursor++;
        break;
      case 4:
        if (obterHora() >= 24) return oldValue;
        final minuto = int.parse(newValue.text.substring(2, 4));
        if (minuto >= 60) return oldValue;
        valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}:');
        if (newValue.selection.end >= 2) posicaoCursor++;
        break;
    }

    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
