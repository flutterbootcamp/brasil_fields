import 'package:flutter/services.dart';

/// Contrato para formatadores encadeados por `CompoundFormatter`.
abstract class CompoundableFormatter extends TextInputFormatter {
  /// Número máximo de caracteres aceitos pelo formatador.
  int get maxLength;
}
