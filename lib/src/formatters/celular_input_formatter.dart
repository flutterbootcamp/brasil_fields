import 'telefone_mask_input_formatter.dart';

/// Formata celular com até 11 dígitos: `(XX) XXXXX-XXXX`.
class CelularInputFormatter extends TelefoneMaskInputFormatter {
  @override
  int get maxLength => 11;

  @override
  int get digitosAntesDoHifen => 5;
}
