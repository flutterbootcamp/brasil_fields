import '../formatters/adiciona_separador.dart';
import '../validators/validators.dart';

class UtilBrasilFields {
  /// Remover caracteres especiais (ex: `/`, `-`, `.`)
  static String removeCaracteres(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  /// Remover o símbolo `R$`
  static String removerSimboloMoeda(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll('R\$ ', '');
  }

  /// Converter o valor de uma String com `R$`
  static double converterMoedaParaDouble(String valor) {
    assert(valor.isNotEmpty);
    final value = double.tryParse(
        valor.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));

    return value ?? 0;
  }

  /// Retorna o CNPJ informado, utilizando a máscara: `XX.YYY-ZZZ`
  ///
  /// Para remover o `.`, informe `ponto=false`.
  static String obterCep(String cep, {bool ponto = true}) {
    assert(
        cep.length == 8, 'CEP com tamanho inválido. Deve conter 8 caracteres');

    return ponto
        ? '${cep.substring(0, 2)}.${cep.substring(2, 5)}-${cep.substring(5, 8)}'
        : '${cep.substring(0, 2)}${cep.substring(2, 5)}-${cep.substring(5, 8)}';
  }

  /// Retorna o telefone informado, utilizando a máscara: `(00) 11111-2222`
  ///
  /// Ajusta-se automaticamente para celular e fixo.
  ///
  /// Para retornar apenas os números, informe `mascara=false`.
  static String obterTelefone(String telefone,
      {bool ddd = true, bool mascara = true}) {
    assert((telefone.length <= 15),
        'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres');
    if (!mascara) return UtilBrasilFields.removeCaracteres(telefone);

    if (ddd) {
      assert((telefone.length == 10 || telefone.length == 11),
          'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres');

      return telefone.length == 10
          ? '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6, 10)}'
          : '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
    } else {
      assert((telefone.length == 8 || telefone.length == 9),
          'Telefone com tamanho inválido. Deve conter 8 ou 9 caracteres');

      return (telefone.length == 8)
          ? '${telefone.substring(0, 4)}-${telefone.substring(4, 8)}'
          : '${telefone.substring(0, 5)}-${telefone.substring(5, 9)}';
    }
  }

  static String obterDDD(String telefone) {
    assert((telefone.length == 14 || telefone.length == 15),
        'Telefone com tamanho inválido. Deve conter 14 ou 15 caracteres');

    return telefone.substring(1, 3);
  }

  ///Faz a validação do CPF retornando `[true]` ou `[false]`
  static bool isCPFValido(String? cpf) => CPFValidator.isValid(cpf);

  ///Faz a validação do CNPJ retornando `[true]` ou `[false]`
  static bool isCNPJValido(String? cnpj) => CNPJValidator.isValid(cnpj);

  /// Gera um CPF aleatório
  ///
  /// Formatado ou não formatado, baseado no parâmetro `useFormat`:
  ///
  /// `true`: CPF gerado terá o formato `XXX.XXX.XXX-XX`
  ///
  /// `false`: CPF gerado terá o formato `XXXXXXXXXXX`
  static String gerarCPF({bool useFormat = false}) =>
      CPFValidator.generate(useFormat: useFormat);

  /// Gera um CNPJ aleatório
  ///
  /// Formatado ou não formatado, baseado no parâmetro `useFormat`:
  ///
  /// `true`: CNPJ gerado terá o formato `XX.YYY.ZZZ/NNNN-SS`
  ///
  /// `false`: CNPJ gerado terá o formato `XXYYYZZZNNNNSS`
  static String gerarCNPJ({bool useFormat = false}) =>
      CNPJValidator.generate(useFormat: useFormat);

  /// Retorna o CPF utilizando a máscara: `XXX.YYY.ZZZ-NN`
  static String obterCpf(String cpf) {
    assert(isCPFValido(cpf), 'CPF inválido!');
    return CPFValidator.format(cpf);
  }

  /// Retorna o CNPJ informado, utilizando a máscara: `XX.YYY.ZZZ/NNNN-SS`
  static String obterCnpj(String cnpj) {
    assert(isCNPJValido(cnpj), 'CNPJ inválido!');
    return CNPJValidator.format(cnpj);
  }

  /// Retorna os dígitos da inscrição do [cnpj] informado.
  ///
  /// Formatado ou não formatado, baseado no parâmetro `useFormat`:
  ///
  /// `true`: inscrição terá o formato `XX.YYY.ZZZ`
  ///
  /// `false`: inscrição terá o formato `XXYYYZZZ`
  static String obterInscricaoCnpj(String cnpj, {bool useFormat = false}) {
    assert(isCNPJValido(cnpj), 'CNPJ inválido!');
    return useFormat
        ? CNPJValidator.format(cnpj).substring(0, 10)
        : CNPJValidator.strip(cnpj).substring(0, 8);
  }

  /// Retorna os dígitos da ordem do [cnpj] informado.
  ///
  /// A ordem do CNPJ são os 4 dígitos após a barra. Essa parte representa se o
  /// estabelecimento é matriz ou filial (0001 = matriz, 0002 = filial).
  static String obterOrdemCnpj(String cnpj) {
    assert(isCNPJValido(cnpj), 'CNPJ inválido!');
    return CNPJValidator.strip(cnpj).substring(8, 12);
  }

  /// Retorna os dígitos verificadores do [cnpj] informado.
  ///
  /// Os dígitos verificadores são os dois últimos números do CNPJ.
  static String obterDivCnpj(String cnpj) {
    assert(isCNPJValido(cnpj), 'CNPJ inválido!');
    return CNPJValidator.strip(cnpj).substring(12);
  }

  /// Retorna o número real informado, utilizando a máscara: `R$ 50.000,00` ou `50.000,00`
  static String obterReal(double value, {bool moeda = true, int decimal = 2}) {
    bool isNegative = false;

    if (value.isNegative) {
      isNegative = true;
      value = value * (-1);
    }

    String fixed = value.toStringAsFixed(decimal);
    List<String> separatedValues = fixed.split(".");

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

  /// Retorna o KM informado, utilizando a máscara: `XXX.XXX`
  static String obterKM(int km) {
    assert(
        km <= 999999, 'KM informado inválido. Valor máximo permitido é 999999');
    final kmString = km.toString();
    switch (kmString.length) {
      case 4:
        return "${kmString[0]}.${kmString[1]}${kmString[2]}${kmString[3]}";
      case 5:
        return "${kmString[0]}${kmString[1]}.${kmString[2]}${kmString[3]}${kmString[4]}";
      case 6:
        return "${kmString[0]}${kmString[1]}${kmString[2]}.${kmString[3]}${kmString[4]}${kmString[5]}";
      default:
        return km.toString();
    }
  }
}
