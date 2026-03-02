import '../cnpj_alfanumerico_input_formatter.dart';
import 'compound_formatter.dart';
import '../cpf_input_formatter.dart';

class CpfOuCnpjAlfanumericoFormatter extends CompoundFormatter {
  CpfOuCnpjAlfanumericoFormatter()
      : super([CpfInputFormatter(), CnpjAlfanumericoInputFormatter()]);
}
