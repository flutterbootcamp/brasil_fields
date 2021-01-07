import 'package:brasil_fields/src/formatters/cnpj_input_formatter.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:brasil_fields/src/formatters/cpf_input_formatter.dart';

class CpfOuCnpjFormatter extends CompoundFormatter {
  CpfOuCnpjFormatter() : super([CpfInputFormatter(), CnpjInputFormatter()]);
}
