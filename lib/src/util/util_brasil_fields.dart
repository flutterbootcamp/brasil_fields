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

    return '${telefone.substring(1, 3)}';
  }

  ///Faz a validação do CPF retornando `[true]` ou `[false]`
  static bool isCPFValido(String? cpf) => CPFValidator.isValid(cpf);

  ///Faz a validação do CNPJ retornando `[true]` ou `[false]`
  static bool isCNPJValido(String? cnpj) => CNPJValidator.isValid(cnpj);

  ///Gera um CPF aleatório
  static String gerarCPF({bool useFormat = false}) =>
      CPFValidator.generate(useFormat: useFormat);

  ///Gera um CNPJ aleatório
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
}
