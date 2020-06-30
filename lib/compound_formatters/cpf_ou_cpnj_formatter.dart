import 'package:brasil_fields/brasil_fields.dart';

class CpfOuCnpjFormatter extends CompoundFormatter {
  CpfOuCnpjFormatter()
      : super([
          CpfInputFormatter(),
          CnpjInputFormatter(),
        ]);
}
