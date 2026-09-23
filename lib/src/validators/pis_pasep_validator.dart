import 'dart:math';

/// Valida, formata e gera números de PIS/PASEP, NIT e NIS.
class PisPasepValidator {
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

  /// Pesos utilizados no cálculo do dígito verificador.
  static const List<int> _weights = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  // Calcula o dígito verificador pelo módulo 11.
  // Informações institucionais sobre o PIS/PASEP:
  // https://www.gov.br/trabalho-e-emprego/pt-br/servicos/trabalhador/abono-salarial
  static int _verifierDigit(String pis) {
    var soma = 0;

    for (var i = 0; i < _weights.length; i++) {
      soma += int.parse(pis[i], radix: 10) * _weights[i];
    }

    final resto = soma % 11;

    return resto < 2 ? 0 : 11 - resto;
  }

  /// Formata o PIS/PASEP com a máscara `XXX.XXXXX.XX-X`.
  static String format(String pis) {
    final regExp = RegExp(r'^(\d{3})(\d{5})(\d{2})(\d{1})$');

    return strip(
      pis,
    ).replaceAllMapped(regExp, (Match m) => '${m[1]}.${m[2]}.${m[3]}-${m[4]}');
  }

  /// Remove caracteres não numéricos do PIS/PASEP.
  static String strip(String? pis) {
    final regExp = RegExp(stripRegex);
    pis = pis ?? '';

    return pis.replaceAll(regExp, '');
  }

  /// Retorna `true` se [pis] tem formato e dígito verificador válidos.
  ///
  /// Remove caracteres não numéricos antes da validação quando
  /// [stripBeforeValidation] é `true`.
  static bool isValid(String? pis, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      pis = strip(pis);
    }

    if (pis == null || pis.isEmpty) {
      return false;
    }

    if (pis.length != 11) {
      return false;
    }

    if (!RegExp(r'^\d{11}$').hasMatch(pis)) {
      return false;
    }

    if (blockList.contains(pis)) {
      return false;
    }

    return _verifierDigit(pis).toString() == pis[10];
  }

  /// Gera um PIS/PASEP válido, formatado quando [useFormat] é `true`.
  static String generate({bool useFormat = false, Random? random}) {
    final generator = random ?? Random();

    for (var attempt = 0; attempt < _maxGenerationAttempts; attempt++) {
      var numbers = '';

      for (var i = 0; i < 10; i += 1) {
        numbers += generator.nextInt(10).toString();
      }
      numbers += _verifierDigit(numbers).toString();

      if (!blockList.contains(numbers)) {
        return useFormat ? format(numbers) : numbers;
      }
    }

    throw StateError(
      'Não foi possível gerar um PIS/PASEP fora da lista de bloqueio após '
      '$_maxGenerationAttempts tentativas.',
    );
  }
}
