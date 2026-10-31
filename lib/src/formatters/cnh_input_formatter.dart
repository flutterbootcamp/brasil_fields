import 'package:flutter/services.dart';

/// Limita o campo aos 11 dígitos do número de registro da CNH.
///
/// O número de registro não usa separadores, portanto o texto é mantido como
/// digitado, incluindo a seleção: o formatador apenas impede que o campo
/// passe de [maxLength].
class CNHInputFormatter extends TextInputFormatter {
  /// Número máximo de caracteres aceitos pelo formatador.
  int get maxLength => 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;

    if (newValue.text.length > maxLength) return oldValue;

    return newValue;
  }
}
