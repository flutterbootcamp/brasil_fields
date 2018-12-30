import 'dart:math' as math;

import 'package:flutter/services.dart';

/// Limita de cada formatter do package
abstract class MaxLengthInputFormatter {
  TextEditingValue truncateLength(int maxLength, TextEditingValue newValue) {
    final TextSelection newSelection = newValue.selection.copyWith(
      baseOffset: math.min(newValue.selection.start, maxLength),
      extentOffset: math.min(newValue.selection.end, maxLength),
    );

    final RuneIterator iterator = RuneIterator(newValue.text);
    if (iterator.moveNext())
      for (int count = 0; count < maxLength; ++count)
        if (!iterator.moveNext()) break;
    final String truncated = newValue.text.substring(0, iterator.rawIndex);
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
