import '../cnpj_input_formatter.dart';
import 'compound_formatter.dart';
import '../cpf_input_formatter.dart';

class CpfOuCnpjFormatter extends CompoundFormatter {
  CpfOuCnpjFormatter() : super([CpfInputFormatter(), CnpjInputFormatter()]);
}
