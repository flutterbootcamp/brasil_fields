import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

export 'package:flutter/services.dart'
    show TextEditingValue, TextRange, TextSelection;

TextEditingValue textEditingValue(
  String text, {
  TextSelection? selection,
  TextRange composing = TextRange.empty,
}) {
  return TextEditingValue(
    text: text,
    selection: selection ?? TextSelection.collapsed(offset: text.length),
    composing: composing,
  );
}

TextEditingValue applyFormatterChain(
  List<TextInputFormatter> formatters,
  TextEditingValue oldValue,
  TextEditingValue newValue,
) {
  return formatters.fold(
    newValue,
    (value, formatter) => formatter.formatEditUpdate(oldValue, value),
  );
}

List<TextInputFormatter> numericFormatterChain(TextInputFormatter formatter) =>
    [FilteringTextInputFormatter.digitsOnly, formatter];

List<TextInputFormatter> alphaNumericFormatterChain(
  TextInputFormatter formatter,
) =>
    [
      FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
      formatter,
    ];

void expectActiveComposingIsUnchanged(
  List<TextInputFormatter> formatters,
  TextEditingValue oldValue,
  TextEditingValue newValue,
) {
  expect(applyFormatterChain(formatters, oldValue, newValue), newValue);
}

void expectCollapsedSelectionAtEnd(TextEditingValue value) {
  expect(value.selection, TextSelection.collapsed(offset: value.text.length));
}
