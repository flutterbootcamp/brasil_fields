import '../cnpj_input_formatter.dart';
import 'compound_formatter.dart';
import '../cpf_input_formatter.dart';

/// Formata CPF ou CNPJ conforme o tamanho do valor.
class CpfOuCnpjFormatter extends CompoundFormatter {
  CpfOuCnpjFormatter() : super([CpfInputFormatter(), CnpjInputFormatter()]);
}
