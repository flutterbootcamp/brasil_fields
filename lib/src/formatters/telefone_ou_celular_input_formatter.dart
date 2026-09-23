import 'package:flutter/services.dart';

import 'celular_input_formatter.dart';
import 'telefone_fixo_input_formatter.dart';

/// Formata telefone fixo ou celular conforme a quantidade de dígitos.
///
/// Até 10 dígitos, usa a máscara de telefone fixo. Com 11 dígitos, usa a
/// máscara de celular.
class TelefoneOuCelularInputFormatter extends TextInputFormatter {
  final _telefoneFixo = TelefoneFixoInputFormatter();
  final _celular = CelularInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    return newValue.text.length <= _telefoneFixo.maxLength
        ? _telefoneFixo.formatEditUpdate(oldValue, newValue)
        : _celular.formatEditUpdate(oldValue, newValue);
  }
}
