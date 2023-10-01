import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara de CEP `XX.XXX-XXX`
///
/// `ponto` indica se o formato do CEP deve utilizar `.` ou não.
class CepInputFormatter extends TextInputFormatter {
  final bool ponto;

  CepInputFormatter({this.ponto = true});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 8) return oldValue;

    final valorFinal = StringBuffer();
    int posicaoCursor = newValue.selection.end;

    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 2 && ponto) {
        valorFinal.write('.');
        if (posicaoCursor > i) posicaoCursor++;
      }
      if (i == 5) {
        valorFinal.write('-');
        if (posicaoCursor > i) posicaoCursor++;
      }
      valorFinal.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
