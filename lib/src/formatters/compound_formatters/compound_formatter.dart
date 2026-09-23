import '../../interfaces/compoundable_formatter.dart';
import 'package:flutter/services.dart';

/// Usa o primeiro formatador cujo limite comporte a entrada.
///
/// Se nenhum comportar a entrada, usa o primeiro da lista.
class CompoundFormatter extends TextInputFormatter {
  /// Formatadores consultados na ordem em que foram informados.
  final List<CompoundableFormatter> _formatters;

  CompoundFormatter(this._formatters)
      : assert(_formatters.isNotEmpty),
        assert(_formatters.length > 1);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;

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
