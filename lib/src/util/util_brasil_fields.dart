import 'dart:math';

import '../formatters/adiciona_separador.dart';
import '../validators/validators.dart';

class UtilBrasilFields {
  static final RegExp _simboloMoeda = RegExp(r'R\$[ \u00A0]?');

  /// Remove caracteres que não sejam letras ASCII ou dígitos.
  static String removeCaracteres(String valor) {
    if (valor.isEmpty) {
      throw ArgumentError.value(valor, 'valor', 'não pode estar vazio');
    }
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  /// Remove o símbolo `R$` e o espaço opcional após ele.
  static String removerSimboloMoeda(String valor) {
    if (valor.isEmpty) {
      throw ArgumentError.value(valor, 'valor', 'não pode estar vazio');
    }
    return valor.replaceAll(_simboloMoeda, '');
  }

  /// Converte um valor monetário brasileiro em [double].
  ///
  /// Aceita o símbolo `R$` e retorna `0` se o valor não puder ser convertido.
  static double converterMoedaParaDouble(String valor) {
    if (valor.isEmpty) {
      throw ArgumentError.value(valor, 'valor', 'não pode estar vazio');
    }
    final value = double.tryParse(
      valor
          .replaceAll(_simboloMoeda, '')
          .replaceAll('.', '')
          .replaceAll(',', '.'),
    );

    return value ?? 0;
  }

  /// Formata um CEP de oito caracteres como `XX.XXX-XXX`.
  ///
  /// Com [ponto] igual a `false`, retorna `XXXXX-XXX`.
  static String obterCep(String cep, {bool ponto = true}) {
    if (cep.length != 8) {
      throw ArgumentError.value(
        cep,
        'cep',
        'CEP com tamanho inválido. Deve conter 8 caracteres',
      );
    }

    return ponto
        ? '${cep.substring(0, 2)}.${cep.substring(2, 5)}-${cep.substring(5, 8)}'
        : '${cep.substring(0, 2)}${cep.substring(2, 5)}-${cep.substring(5, 8)}';
  }

  /// Formata um telefone fixo ou celular, com ou sem DDD.
  ///
  /// Com [mascara] igual a `true`, aceita 10 ou 11 caracteres quando [ddd]
  /// é `true`, ou 8 ou 9 caracteres quando [ddd] é `false`.
  /// Com [mascara] igual a `false`, mantém apenas letras ASCII e dígitos;
  /// nesse caso, [ddd] é ignorado e a entrada aceita até 15 caracteres.
  static String obterTelefone(
    String telefone, {
    bool ddd = true,
    bool mascara = true,
  }) {
    if (telefone.length > 15) {
      throw ArgumentError.value(
        telefone,
        'telefone',
        'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres',
      );
    }
    if (!mascara) return UtilBrasilFields.removeCaracteres(telefone);

    if (ddd) {
      if (telefone.length != 10 && telefone.length != 11) {
        throw ArgumentError.value(
          telefone,
          'telefone',
          'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres',
        );
      }

      return telefone.length == 10
          ? '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6, 10)}'
          : '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
    } else {
      if (telefone.length != 8 && telefone.length != 9) {
        throw ArgumentError.value(
          telefone,
          'telefone',
          'Telefone com tamanho inválido. Deve conter 8 ou 9 caracteres',
        );
      }

      return (telefone.length == 8)
          ? '${telefone.substring(0, 4)}-${telefone.substring(4, 8)}'
          : '${telefone.substring(0, 5)}-${telefone.substring(5, 9)}';
    }
  }

  /// Extrai o DDD de um telefone no formato `(XX) XXXX-XXXX` ou
  /// `(XX) XXXXX-XXXX`.
  static String obterDDD(String telefone) {
    if (telefone.length != 14 && telefone.length != 15) {
      throw ArgumentError.value(
        telefone,
        'telefone',
        'Telefone com tamanho inválido. Deve conter 14 ou 15 caracteres',
      );
    }

    return telefone.substring(1, 3);
  }

  /// Retorna `true` se o CPF for válido.
  static bool isCPFValido(String? cpf) => CPFValidator.isValid(cpf);

  /// Retorna `true` se o CNPJ for válido.
  ///
  /// Com [isAlphanumeric] igual a `true`, valida o padrão alfanumérico.
  static bool isCNPJValido(String? cnpj, {bool isAlphanumeric = false}) =>
      isAlphanumeric
          ? CnpjAlfanumericoValidator.isValid(cnpj)
          : CNPJValidator.isValid(cnpj);

  /// Retorna `true` se o NUP for válido.
  static bool isNUPValido(String? nup) => NUPValidator.isValid(nup);

  /// Retorna `true` se o PIS/PASEP (NIT/NIS) for válido.
  static bool isPisPasepValido(String? pis) => PisPasepValidator.isValid(pis);

  /// Gera um CPF válido aleatório.
  ///
  /// Com [useFormat] igual a `true`, retorna `XXX.XXX.XXX-XX`;
  /// caso contrário, retorna apenas os 11 dígitos.
  static String gerarCPF({bool useFormat = false, Random? random}) =>
      CPFValidator.generate(useFormat: useFormat, random: random);

  /// Gera um CNPJ válido aleatório.
  ///
  /// Com [useFormat] igual a `true`, retorna `XX.XXX.XXX/XXXX-XX`;
  /// caso contrário, retorna os 14 caracteres sem pontuação.
  /// Com [isAlphanumeric] igual a `true`, usa o padrão alfanumérico.
  static String gerarCNPJ({
    bool useFormat = false,
    bool isAlphanumeric = false,
    Random? random,
  }) =>
      isAlphanumeric
          ? CnpjAlfanumericoValidator.generate(
              useFormat: useFormat,
              random: random,
            )
          : CNPJValidator.generate(useFormat: useFormat, random: random);

  /// Gera um PIS/PASEP (NIT/NIS) válido aleatório.
  ///
  /// Com [useFormat] igual a `true`, retorna `XXX.XXXXX.XX-X`;
  /// caso contrário, retorna apenas os 11 dígitos.
  static String gerarPisPasep({bool useFormat = false, Random? random}) =>
      PisPasepValidator.generate(useFormat: useFormat, random: random);

  /// Formata um CPF válido como `XXX.XXX.XXX-XX`.
  static String obterCpf(String cpf) {
    if (!isCPFValido(cpf)) {
      throw ArgumentError.value(cpf, 'cpf', 'CPF inválido!');
    }
    return CPFValidator.format(cpf);
  }

  /// Formata um CNPJ válido, inclusive alfanumérico, como
  /// `XX.XXX.XXX/XXXX-XX`.
  static String obterCnpj(String cnpj) {
    if (!isCNPJValido(cnpj, isAlphanumeric: true)) {
      throw ArgumentError.value(cnpj, 'cnpj', 'CNPJ inválido!');
    }
    return CnpjAlfanumericoValidator.format(cnpj);
  }

  /// Retorna os oito primeiros caracteres da inscrição do [cnpj] válido.
  ///
  /// Com [useFormat] igual a `true`, retorna `XX.XXX.XXX`;
  /// caso contrário, retorna os caracteres sem pontuação.
  static String obterCnpjInscricao(String cnpj, {bool useFormat = false}) {
    if (!isCNPJValido(cnpj, isAlphanumeric: true)) {
      throw ArgumentError.value(cnpj, 'cnpj', 'CNPJ inválido!');
    }
    return useFormat
        ? CnpjAlfanumericoValidator.format(cnpj).substring(0, 10)
        : CnpjAlfanumericoValidator.strip(cnpj).substring(0, 8);
  }

  /// Retorna os quatro caracteres da ordem do [cnpj] válido.
  ///
  /// A ordem aparece após a barra no CNPJ formatado e identifica o
  /// estabelecimento (por exemplo, `0001` para a matriz).
  static String obterCnpjOrdem(String cnpj) {
    if (!isCNPJValido(cnpj, isAlphanumeric: true)) {
      throw ArgumentError.value(cnpj, 'cnpj', 'CNPJ inválido!');
    }
    return CnpjAlfanumericoValidator.strip(cnpj).substring(8, 12);
  }

  /// Retorna os dois dígitos verificadores do [cnpj] válido.
  static String obterCnpjDiv(String cnpj) {
    if (!isCNPJValido(cnpj, isAlphanumeric: true)) {
      throw ArgumentError.value(cnpj, 'cnpj', 'CNPJ inválido!');
    }
    return CnpjAlfanumericoValidator.strip(cnpj).substring(12);
  }

  /// Formata um PIS/PASEP válido como `XXX.XXXXX.XX-X`.
  static String obterPisPasep(String pis) {
    if (!isPisPasepValido(pis)) {
      throw ArgumentError.value(pis, 'pis', 'PIS/PASEP inválido!');
    }
    return PisPasepValidator.format(pis);
  }

  /// Formata um NUP válido como `NNNNNNN-DD.AAAA.J.TR.OOOO`.
  static String obterNUP(String nup) {
    if (!isNUPValido(nup)) {
      throw ArgumentError.value(nup, 'nup', 'Número de Processo inválido!');
    }
    return NUPValidator.format(nup);
  }

  /// Formata [value] com separadores brasileiros e [decimal] casas decimais.
  ///
  /// Inclui `R$ ` quando [moeda] é `true`.
  static String obterReal(double value, {bool moeda = true, int decimal = 2}) {
    bool isNegative = false;

    if (value.isNegative) {
      isNegative = true;
      value = value * (-1);
    }

    final String fixed = value.toStringAsFixed(decimal);
    final List<String> separatedValues = fixed.split(".");

    separatedValues[0] = adicionarSeparador(separatedValues[0]);
    String formatted = separatedValues.join(",");

    if (isNegative) {
      formatted = "-$formatted";
    }

    if (moeda) {
      return r"R$ " + formatted;
    } else {
      return formatted;
    }
  }

  /// Formata [km] com separador de milhares; aceita valores até `999999`.
  static String obterKM(int km) {
    if (km > 999999) {
      throw ArgumentError.value(
        km,
        'km',
        'KM informado inválido. Valor máximo permitido é 999999',
      );
    }
    return adicionarSeparador(km.toString());
  }
}
