import 'package:brasil_fields/brasil_fields.dart';

class CPFToCNPJFormatter extends CompoundFormatter {
  CPFToCNPJFormatter()
      : super([
          CpfInputFormatter(),
          CnpjInputFormatter(),
        ]);
}
