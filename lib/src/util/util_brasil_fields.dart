class UtilBrasilFields {
  static String removeCaracteres(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  static String obterCpf(String cpf) {
    assert(cpf.length == 11);
    return cpf.substring(0, 3) +
        '.' +
        cpf.substring(3, 6) +
        '.' +
        cpf.substring(6, 9) +
        '-' +
        cpf.substring(9, 11);
  }

  static String obterCnpj(String cnpj) {
    assert(cnpj.length == 14);
    return cnpj.substring(0, 2) +
        '.' +
        cnpj.substring(2, 5) +
        '.' +
        cnpj.substring(5, 8) +
        '/' +
        cnpj.substring(8, 12) +
        '-' +
        cnpj.substring(12, 14);
  }

  static String obterCep(String cep) {
    assert(cep.length == 8);
    return cep.substring(0, 2) +
        '.' +
        cep.substring(2, 5) +
        '-' +
        cep.substring(5, 8);
  }
}
