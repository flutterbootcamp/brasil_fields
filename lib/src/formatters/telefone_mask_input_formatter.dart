import 'package:flutter/services.dart';

final _digitPattern = RegExp(r'\d');

/// Aplica uma máscara telefônica limitada a uma quantidade de dígitos.
abstract class TelefoneMaskInputFormatter extends TextInputFormatter {
  /// Limite de dígitos aceitos pelo formatador.
  int get maxLength;

  /// Quantidade de dígitos do assinante antes do hífen.
  int get digitosAntesDoHifen;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    if (newValue.text.length > maxLength) return oldValue;

    var substrIndex = 0;
    final valorFinal = StringBuffer();

    if (newValue.text.isNotEmpty) {
      valorFinal.write('(');
    }

    if (newValue.text.length >= 3) {
      valorFinal.write('${newValue.text.substring(0, substrIndex = 2)}) ');
    }

    final limiteHifen = 2 + digitosAntesDoHifen;
    if (newValue.text.length > limiteHifen) {
      valorFinal.write(
        '${newValue.text.substring(2, substrIndex = limiteHifen)}-',
      );
    }

    if (newValue.text.length >= substrIndex) {
      valorFinal.write(newValue.text.substring(substrIndex));
    }

    final textoFormatado = valorFinal.toString();
    final selectionEnd = newValue.selection.end.clamp(0, newValue.text.length);
    final digitosAntesDoCursor = _digitPattern
        .allMatches(newValue.text.substring(0, selectionEnd))
        .length;
    var digitosPercorridos = 0;
    var posicaoCursor = 0;
    if (digitosAntesDoCursor > 0) {
      for (var i = 0; i < textoFormatado.length; i++) {
        if (_digitPattern.hasMatch(textoFormatado[i])) {
          digitosPercorridos++;
          posicaoCursor = i + 1;
          if (digitosPercorridos == digitosAntesDoCursor) break;
        }
      }
    }

    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
