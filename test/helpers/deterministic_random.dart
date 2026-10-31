import 'dart:math';

/// Implementação determinística de [Random] que registra os limites superiores
/// exclusivos solicitados pelo código testado.
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

/// Calcula os dígitos verificadores da CNH a partir de uma base de 9 dígitos.
///
/// Retorna `null` para bases que não admitem número de registro válido.
String? cnhWithIndependentCheckDigits(String body) {
  const firstWeights = <int>[9, 8, 7, 6, 5, 4, 3, 2, 1];
  const secondWeights = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];

  var firstSum = 0;
  var secondSum = 0;
  for (var index = 0; index < body.length; index++) {
    final value = int.parse(body[index]);
    firstSum += value * firstWeights[index];
    secondSum += value * secondWeights[index];
  }

  final firstRemainder = firstSum % 11;
  final first = firstRemainder > 9 ? 0 : firstRemainder;
  final reduction = firstRemainder > 9 ? 2 : 0;

  final secondRemainder = secondSum % 11;
  var second = secondRemainder > 9 ? 0 : secondRemainder - reduction;
  if (second < 0) {
    second += 11;
  }

  if (second > 9) {
    return null;
  }

  return '$body$first$second';
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
