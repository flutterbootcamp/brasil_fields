import 'package:brasil_fields/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Combines two or more [Formatter] instances such that
/// it's possible to interpolate from the actual to the next
class CompoundFormatter extends TextInputFormatter {
  /// Stores a series of [CompoundableFormatter] instances which are chained
  /// in the same order as they are positioned in the List
  final List<CompoundableFormatter> _formatters;

  CompoundFormatter(this._formatters)
      : assert(_formatters != null),
        assert(_formatters.isNotEmpty),
        assert(_formatters.length > 1);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final delegatedFormatter = _formatters.firstWhere((formatter) {
      final newValueLength = newValue.text.length;
      final maxLength = formatter.maxLength;
      return newValueLength <= maxLength;
    }, orElse: () {
      return _formatters.first;
    });
    return delegatedFormatter.formatEditUpdate(oldValue, newValue);
  }
}
