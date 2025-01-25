import 'package:brasil_fields/src/formatters/cnpj_alfanumerico_input_formatter.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:brasil_fields/src/formatters/cpf_input_formatter.dart';

class CpfOuCnpjAlfanumericoFormatter extends CompoundFormatter {
  CpfOuCnpjAlfanumericoFormatter()
      : super([CpfInputFormatter(), CnpjAlfanumericoInputFormatter()]);
}
