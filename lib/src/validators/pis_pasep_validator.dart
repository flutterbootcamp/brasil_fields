import 'dart:math';

/// Validador do PIS/PASEP, também conhecido como NIT (Número de Identificação
/// do Trabalhador) ou NIS (Número de Identificação Social).
///
/// Todos utilizam o mesmo número de 11 dígitos e o mesmo dígito verificador.
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

  /// Pesos utilizados no cálculo do dígito verificador.
  static const List<int> _weights = [3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  // calcula o Dígito Verificador (DV)
  // mais informações em [Caixa (pt-br)](https://www.caixa.gov.br/beneficios-trabalhador/pis/Paginas/default.aspx)
  static int _verifierDigit(String pis) {
    var soma = 0;

    for (var i = 0; i < _weights.length; i++) {
      soma += int.parse(pis[i], radix: 10) * _weights[i];
    }

    final resto = soma % 11;

    return resto < 2 ? 0 : 11 - resto;
  }

  /// Retorna o PIS/PASEP informado, utilizando a máscara: `XXX.XXXXX.XX-X`
  static String format(String pis) {
    final regExp = RegExp(r'^(\d{3})(\d{5})(\d{2})(\d{1})$');

    return strip(
      pis,
    ).replaceAllMapped(regExp, (Match m) => '${m[1]}.${m[2]}.${m[3]}-${m[4]}');
  }

  /// Remove os caracteres não numéricos do PIS/PASEP informado.
  static String strip(String? pis) {
    final regExp = RegExp(stripRegex);
    pis = pis ?? '';

    return pis.replaceAll(regExp, '');
  }

  /// Faz a validação do PIS/PASEP retornando `[true]` ou `[false]`.
  static bool isValid(String? pis, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      pis = strip(pis);
    }

    // PIS/PASEP deve ser informado
    if (pis == null || pis.isEmpty) {
      return false;
    }

    // PIS/PASEP deve ter 11 caracteres
    if (pis.length != 11) {
      return false;
    }

    // PIS/PASEP deve conter apenas dígitos
    if (strip(pis).length != 11) {
      return false;
    }

    // PIS/PASEP não pode estar na lista de bloqueio
    if (blockList.contains(pis)) {
      return false;
    }

    return _verifierDigit(pis).toString() == pis[10];
  }

  /// Gera um PIS/PASEP aleatório válido.
  static String generate({bool useFormat = false}) {
    final random = Random();
    var numbers = '';

    do {
      numbers = '';
      for (var i = 0; i < 10; i += 1) {
        numbers += random.nextInt(10).toString();
      }
      numbers += _verifierDigit(numbers).toString();
    } while (blockList.contains(numbers));

    return useFormat ? format(numbers) : numbers;
  }
}
