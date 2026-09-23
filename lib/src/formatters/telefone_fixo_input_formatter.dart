import 'telefone_mask_input_formatter.dart';

/// Formata telefone fixo com até 10 dígitos: `(XX) XXXX-XXXX`.
class TelefoneFixoInputFormatter extends TelefoneMaskInputFormatter {
  @override
  int get maxLength => 10;

  @override
  int get digitosAntesDoHifen => 4;
}
