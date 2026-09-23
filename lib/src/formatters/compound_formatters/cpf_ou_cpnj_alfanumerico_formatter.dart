import '../cnpj_alfanumerico_input_formatter.dart';
import 'compound_formatter.dart';
import '../cpf_input_formatter.dart';

/// Formata CPF numérico ou CNPJ alfanumérico conforme o tamanho do valor.
class CpfOuCnpjAlfanumericoFormatter extends CompoundFormatter {
  CpfOuCnpjAlfanumericoFormatter()
      : super([CpfInputFormatter(), CnpjAlfanumericoInputFormatter()]);
}
