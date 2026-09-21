import 'dart:math';

/// A deterministic [Random] that records the exclusive bounds requested by
/// production code.
class RecordingRandom implements Random {
  RecordingRandom(this._values);

  RecordingRandom.constant(int value) : this(<int>[value]);

  final List<int> _values;
  final List<int> requestedMaxValues = <int>[];
  int _index = 0;

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() => nextInt(1 << 26) / (1 << 26);

  @override
  int nextInt(int max) {
    requestedMaxValues.add(max);
    if (_values.isEmpty) {
      throw StateError('RecordingRandom requires at least one value.');
    }

    final value = _values[_index % _values.length];
    _index++;
    if (value < 0 || value >= max) {
      throw StateError('Value $value is outside Random.nextInt($max).');
    }
    return value;
  }
}

String cpfWithIndependentCheckDigits(String body) {
  int digit(String value) {
    var sum = 0;
    for (var index = 0; index < value.length; index++) {
      sum += int.parse(value[index]) * (value.length + 1 - index);
    }
    final remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  }

  final first = digit(body);
  final second = digit('$body$first');
  return '$body$first$second';
}

String cnpjWithIndependentCheckDigits(String body) {
  int digit(String value) {
    var weight = 2;
    var sum = 0;
    for (final character in value.split('').reversed) {
      final numericValue = character.codeUnitAt(0) - '0'.codeUnitAt(0);
      sum += numericValue * weight;
      weight = weight == 9 ? 2 : weight + 1;
    }
    final remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  }

  final first = digit(body);
  final second = digit('$body$first');
  return '$body$first$second';
}
