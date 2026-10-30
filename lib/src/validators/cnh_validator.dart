import 'dart:math';

/// Valida e gera números de registro de CNH.
///
/// O número de registro tem 11 dígitos, sem máscara, sendo os dois últimos
/// os dígitos verificadores.
class CNHValidator {
  /// Sequências de dígitos repetidos são consideradas inválidas.
  static const List<String> blockList = [
    '00000000000',
    '11111111111',
    '22222222222',
    '33333333333',
    '44444444444',
    '55555555555',
    '66666666666',
    '77777777777',
    '88888888888',
    '99999999999',
  ];

  static const stripRegex = r'[^\d]';
  static const int _maxGenerationAttempts = 100;

  // Calcula os dois dígitos verificadores pelo módulo 11, com pesos de 9 a 1
  // no primeiro dígito e de 1 a 9 no segundo. Quando o primeiro resto é 10, o
  // primeiro dígito é 0 e o segundo é reduzido em 2.
  //
  // Retorna `null` para as bases em que o segundo dígito não cabe em uma casa
  // decimal, ou seja, que não admitem número de registro válido.
  static String? _verifierDigits(String base) {
    var somaPrimeiro = 0;
    var somaSegundo = 0;

    for (var i = 0; i < 9; i++) {
      final digito = int.parse(base[i], radix: 10);
      somaPrimeiro += digito * (9 - i);
      somaSegundo += digito * (i + 1);
    }

    var primeiro = somaPrimeiro % 11;
    final reducao = primeiro >= 10 ? 2 : 0;
    if (primeiro >= 10) {
      primeiro = 0;
    }

    var segundo = somaSegundo % 11;
    if (segundo >= 10) {
      segundo = 0;
    } else {
      segundo -= reducao;
      if (segundo < 0) {
        segundo += 11;
      }
    }

    if (segundo > 9) {
      return null;
    }

    return '$primeiro$segundo';
  }

  /// Remove caracteres não numéricos da CNH.
  static String strip(String? cnh) {
    final regExp = RegExp(stripRegex);
    cnh = cnh ?? '';

    return cnh.replaceAll(regExp, '');
  }

  /// Retorna `true` se [cnh] tem formato e dígitos verificadores válidos.
  ///
  /// Remove caracteres não numéricos antes da validação quando
  /// [stripBeforeValidation] é `true`.
  static bool isValid(String? cnh, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      cnh = strip(cnh);
    }

    if (cnh == null || cnh.isEmpty) {
      return false;
    }

    if (cnh.length != 11) {
      return false;
    }

    if (!RegExp(r'^\d{11}$').hasMatch(cnh)) {
      return false;
    }

    if (blockList.contains(cnh)) {
      return false;
    }

    return _verifierDigits(cnh.substring(0, 9)) == cnh.substring(9);
  }

  /// Gera um número de registro de CNH válido, com 11 dígitos.
  static String generate({Random? random}) {
    final generator = random ?? Random();

    for (var attempt = 0; attempt < _maxGenerationAttempts; attempt++) {
      var base = '';

      for (var i = 0; i < 9; i += 1) {
        base += generator.nextInt(10).toString();
      }

      final digits = _verifierDigits(base);
      if (digits == null) {
        continue;
      }

      final candidate = '$base$digits';
      if (!blockList.contains(candidate)) {
        return candidate;
      }
    }

    throw StateError(
      'Não foi possível gerar uma CNH válida após '
      '$_maxGenerationAttempts tentativas.',
    );
  }
}
