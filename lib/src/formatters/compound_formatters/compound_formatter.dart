import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Combina dois ous mais instâncias de [Formatter] de forma que
/// seja possível interpolar de um para outro
class CompoundFormatter extends TextInputFormatter {
  /// Guarda uma lista de [CompoundableFormatter] que são encadeados
  /// na mesma ordem em que estão posicionados na lista
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
