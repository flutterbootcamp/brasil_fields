class UtilBrasilFields {
  static String removeCaracteres(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  static String obterCpf(String cpf) {
    assert(cpf.length == 11, 'CPF com tamanho inválido. Deve conter 11 caracteres');
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
  }

  static String obterCnpj(String cnpj) {
    assert(cnpj.length == 14, 'CPNJ com tamanho inválido. Deve conter 14 caracteres');
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
  }

  static String obterCep(String cep, {bool ponto = true}) {
    assert(cep.length == 8, 'CEP com tamanho inválido. Deve conter 8 caracteres');

    return ponto
        ? '${cep.substring(0, 2)}.${cep.substring(2, 5)}-${cep.substring(5, 8)}'
        : '${cep.substring(0, 2)}${cep.substring(2, 5)}-${cep.substring(5, 8)}';
  }

  static String obterTelefone(String telefone, {bool ddd = true}) {
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
}
