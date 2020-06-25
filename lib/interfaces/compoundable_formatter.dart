import 'package:flutter/services.dart';

/// Defines a Formatter which can be combined with another one
/// to make the transition from one to another possible
/// Used in [CompoundableFormatter]
abstract class CompoundableFormatter extends TextInputFormatter {
  /// Returns the maximum length from the Formatter
  int get maxLength;
}
