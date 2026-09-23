// Créditos: CPF/CNPJ Validators
// https://github.com/leonardocaldas/flutter-cpf-cnpj-validator

import 'dart:math';

/// Valida, formata e gera números de CNPJ.
class CNPJValidator {
  static const List<String> blockList = [
    '00000000000000',
    '11111111111111',
    '22222222222222',
    '33333333333333',
    '44444444444444',
    '55555555555555',
    '66666666666666',
    '77777777777777',
    '88888888888888',
    '99999999999999',
  ];

  static const stipRegex = r'[^\d]';
  static const int _maxGenerationAttempts = 100;

  // Calcula o dígito verificador pelo módulo 11.
  // Sobre dígitos verificadores:
  // https://pt.wikipedia.org/wiki/D%C3%ADgito_verificador
  static int _verifierDigit(String cnpj) {
    var index = 2;

    final reverse = cnpj.split('').map(int.parse).toList().reversed.toList();

    var sum = 0;

    for (var number in reverse) {
      sum += number * index;
      index = (index == 9 ? 2 : index + 1);
    }

    final mod = sum % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  /// Formata o CNPJ com a máscara `XX.XXX.XXX/XXXX-XX`.
  static String format(String cnpj) {
    final regExp = RegExp(r'^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$');

    return strip(cnpj).replaceAllMapped(
      regExp,
      (Match m) => '${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}',
    );
  }

  /// Remove caracteres não numéricos do CNPJ.
  static String strip(String? cnpj) {
    final regExp = RegExp(stipRegex);
    cnpj = cnpj ?? '';

    return cnpj.replaceAll(regExp, '');
  }

  /// Retorna `true` se [cnpj] tem formato e dígitos verificadores válidos.
  ///
  /// Remove caracteres não numéricos antes da validação quando
  /// [stripBeforeValidation] é `true`.
  static bool isValid(String? cnpj, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      cnpj = strip(cnpj);
    }

    if (cnpj == null || cnpj.isEmpty) {
      return false;
    }

    if (cnpj.length != 14) {
      return false;
    }

    if (!RegExp(r'^\d{14}$').hasMatch(cnpj)) {
      return false;
    }

    if (blockList.contains(cnpj)) {
      return false;
    }

    var numbers = cnpj.substring(0, 12);
    numbers += _verifierDigit(numbers).toString();
    numbers += _verifierDigit(numbers).toString();

    return numbers.substring(numbers.length - 2) ==
        cnpj.substring(cnpj.length - 2);
  }

  /// Gera um CNPJ válido, formatado quando [useFormat] é `true`.
  static String generate({bool useFormat = false, Random? random}) {
    final generator = random ?? Random();

    for (var attempt = 0; attempt < _maxGenerationAttempts; attempt++) {
      var numbers = '';

      for (var i = 0; i < 12; i += 1) {
        numbers += generator.nextInt(10).toString();
      }

      numbers += _verifierDigit(numbers).toString();
      numbers += _verifierDigit(numbers).toString();

      if (!blockList.contains(numbers)) {
        return useFormat ? format(numbers) : numbers;
      }
    }

    throw StateError(
      'Não foi possível gerar um CNPJ fora da lista de bloqueio após '
      '$_maxGenerationAttempts tentativas.',
    );
  }
}
