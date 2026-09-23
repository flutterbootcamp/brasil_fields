// Créditos: CPF/CNPJ Validators
// https://github.com/leonardocaldas/flutter-cpf-cnpj-validator

import 'dart:math';

/// Valida, formata e gera números de CPF.
class CPFValidator {
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
    '12345678909',
  ];

  static const stipRegex = r'[^\d]';
  static const int _maxGenerationAttempts = 100;

  // Calcula o dígito verificador pelo módulo 11.
  // Sobre dígitos verificadores:
  // https://pt.wikipedia.org/wiki/D%C3%ADgito_verificador
  static int _verifierDigit(String cpf) {
    final numbers =
        cpf.split('').map((number) => int.parse(number, radix: 10)).toList();

    final modulus = numbers.length + 1;

    final multiplied = <int>[];

    for (var i = 0; i < numbers.length; i++) {
      multiplied.add(numbers[i] * (modulus - i));
    }

    final mod = multiplied.reduce((buffer, number) => buffer + number) % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  /// Formata o CPF com a máscara `XXX.XXX.XXX-XX`.
  static String format(String cpf) {
    final regExp = RegExp(r'^(\d{3})(\d{3})(\d{3})(\d{2})$');

    return strip(
      cpf,
    ).replaceAllMapped(regExp, (Match m) => '${m[1]}.${m[2]}.${m[3]}-${m[4]}');
  }

  /// Remove caracteres não numéricos do CPF.
  static String strip(String? cpf) {
    final regExp = RegExp(stipRegex);
    cpf = cpf ?? '';

    return cpf.replaceAll(regExp, '');
  }

  /// Retorna `true` se [cpf] tem formato e dígitos verificadores válidos.
  ///
  /// Remove caracteres não numéricos antes da validação quando
  /// [stripBeforeValidation] é `true`.
  static bool isValid(String? cpf, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      cpf = strip(cpf);
    }

    if (cpf == null || cpf.isEmpty) {
      return false;
    }

    if (cpf.length != 11) {
      return false;
    }

    if (!RegExp(r'^\d{11}$').hasMatch(cpf)) {
      return false;
    }

    if (blockList.contains(cpf)) {
      return false;
    }

    var numbers = cpf.substring(0, 9);
    numbers += _verifierDigit(numbers).toString();
    numbers += _verifierDigit(numbers).toString();

    return numbers.substring(numbers.length - 2) ==
        cpf.substring(cpf.length - 2);
  }

  /// Gera um CPF válido, formatado quando [useFormat] é `true`.
  static String generate({bool useFormat = false, Random? random}) {
    final generator = random ?? Random();

    for (var attempt = 0; attempt < _maxGenerationAttempts; attempt++) {
      var numbers = '';

      for (var i = 0; i < 9; i += 1) {
        numbers += generator.nextInt(10).toString();
      }

      numbers += _verifierDigit(numbers).toString();
      numbers += _verifierDigit(numbers).toString();

      if (!blockList.contains(numbers)) {
        return useFormat ? format(numbers) : numbers;
      }
    }

    throw StateError(
      'Não foi possível gerar um CPF fora da lista de bloqueio após '
      '$_maxGenerationAttempts tentativas.',
    );
  }
}
