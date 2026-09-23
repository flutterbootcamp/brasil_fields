import 'package:flutter/services.dart';

import 'telefone_ou_celular_input_formatter.dart';

/// Formata telefone fixo ou celular conforme a quantidade de dígitos.
///
/// Este nome legado mantém o comportamento automático existente. Para escolher
/// o tipo explicitamente, use `TelefoneFixoInputFormatter` ou
/// `CelularInputFormatter`. Para 11 dígitos, também mantém a regra histórica de
/// exigir `9` como primeiro dígito após o DDD.
class TelefoneInputFormatter extends TelefoneOuCelularInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    if (newValue.text.length == 11 && newValue.text[2] != '9') {
      return oldValue;
    }
    return super.formatEditUpdate(oldValue, newValue);
  }
}
