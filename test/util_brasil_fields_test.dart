import 'package:brasil_fields/src/util/extensores.dart';
import 'package:brasil_fields/src/util/util_brasil_fields.dart';
import 'package:brasil_fields/src/util/util_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Remove caracteres', () {
    test('CPF', () {
      const cpf = '111.222.333-44';
      expect(UtilBrasilFields.removeCaracteres(cpf), '11122233344');
    });

    test('CNPJ', () {
      const cnpj = '11.222.333/4444-55';
      const cnpj2 = 'U7.YHQ.1HJ/1MQY-56';
      expect(UtilBrasilFields.removeCaracteres(cnpj), '11222333444455');
      expect(UtilBrasilFields.removeCaracteres(cnpj2), 'U7YHQ1HJ1MQY56');
    });

    test('CEP', () {
      const cep = '11.222-333';
      expect(UtilBrasilFields.removeCaracteres(cep), '11222333');
    });

    test('NUP', () {
      const nup = '0601064-21.2022.6.00.0000';
      expect(UtilBrasilFields.removeCaracteres(nup), '06010642120226000000');
    });

    test('Real', () {
      const real = '11.222';
      expect(UtilBrasilFields.removeCaracteres(real), '11222');
    });
    test('Real sem R\$', () {
      const real = 'R\$ 11.222';
      expect(UtilBrasilFields.removerSimboloMoeda(real), '11.222');
    });

    test('Centavos', () {
      const centavos = '0,99';
      expect(UtilBrasilFields.removeCaracteres(centavos), '099');
    });
    test('Centavos sem R\$', () {
      const centavos = 'R\$ 150,99';
      expect(UtilBrasilFields.removerSimboloMoeda(centavos), '150,99');
    });
    test('Converter moeda (R\$) em double', () {
      const centavos = 'R\$ 11.150,99';
      expect(UtilBrasilFields.converterMoedaParaDouble(centavos), 11150.99);
    });
    test('Obter centavos de um double', () {
      double valor = 1590.9;
      String valorConvertido = valor.obterCentavos;
      expect(valorConvertido, 'R\$ 159090');
    });
    test('Obter centavos de um double sem o símbolo de real', () {
      double valor = 1590.9;
      String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '159090');
    });
    test(
        'Obter centavos de um double sem o símbolo de real onde o valor é menor que 1',
        () {
      double valor = 0.1;
      String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '10');
    });
    test(
        'Obter centavos de um double sem o símbolo de real onde o valor é negativos',
        () {
      double valor = -10.5;
      String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '-1050');
    });
    test(
        'Obter centavos de um double com o símbolo de real onde o valor é negativos',
        () {
      double valor = -10.5;
      String valorConvertido = valor.obterCentavos;
      expect(valorConvertido, '-R\$ 1050');
    });
    test('Obter real de um double', () {
      double valor = 1590.9;
      String valorConvertido = valor.obterReal();
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}1.590,90');
    });
    test('Obter real de um double onde o valor é menor que 100', () {
      double valor = 60.0;
      String valorConvertido = valor.obterReal();
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}60,00');
    });
    test('Obter real sem símbolo de um double onde o valor é menor que 100',
        () {
      double valor = 60.0;
      String valorConvertido = valor.obterRealSemSimbolo();
      expect(valorConvertido, '60,00');
    });
    test(
        'Obter real com tres casas decimais sem símbolo, proveniente de um double',
        () {
      double valor = 2563.55;
      String valorConvertido = valor.obterRealSemSimbolo(3);
      expect(valorConvertido, '2.563,550');
    });
    test('Obter real com tres casas decimais de um double', () {
      double valor = 560.9;
      String valorConvertido = valor.obterReal(3);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}560,900');
    });
    test('Obter real com tres casas decimais e valor negativo de um double',
        () {
      double valor = -560.9;
      String valorConvertido = valor.obterReal(3);
      expect(valorConvertido, '-R\$${String.fromCharCode(160)}560,900');
    });
    test('Obter real com duas casas decimais de um inteiro', () {
      int valor = 350000;
      String valorConvertido = valor.obterReal(2);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}350.000,00');
    });
    test('Obter real com tres casas decimais de um inteiro', () {
      int valor = 560;
      String valorConvertido = valor.obterReal(3);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}560,000');
    });
    test(
        'Obter centavos com tres casas decimais e sem símbolo de real de um inteiro',
        () {
      int valor = 560;
      String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '56000');
    });
    test('Obter centavos de um inteiro negativo sem símbolo de real', () {
      int valor = -105;
      String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '-10500');
    });
    test('Obter real de um inteiro negativo sem símbolo de real', () {
      int valor = -10900;
      String valorConvertido = valor.obterRealSemSimbolo(3);
      expect(valorConvertido, '-10.900,000');
    });
    test('Obter DDD', () {
      const telefone = '(99) 8888-7777';
      expect(UtilBrasilFields.obterDDD(telefone), '99');
    });

    test('Data', () {
      const data = '01/01/1900';
      expect(UtilBrasilFields.removeCaracteres(data), '01011900');
    });

    test('Hora', () {
      const hora = '23:59';
      expect(UtilBrasilFields.removeCaracteres(hora), '2359');
    });
    test('Cartão', () {
      const cartao = '1111 2222 3333 4444';
      expect(UtilBrasilFields.removeCaracteres(cartao), '1111222233334444');
    });
    test('Validade cartão', () {
      const validade = '12/23';
      expect(UtilBrasilFields.removeCaracteres(validade), '1223');
    });

    test('Altura', () {
      const altura = '1,79';
      expect(UtilBrasilFields.removeCaracteres(altura), '179');
    });

    test('Peso', () {
      const peso = '103,5';
      expect(UtilBrasilFields.removeCaracteres(peso), '1035');
    });
  });

  group('Obter data no formato', () {
    test('DD/MM/AAAA', () {
      var dataInformada = DateTime(2020, 12, 31);
      var dataToUtc = UtilData.obterDataDDMMAAAA(dataInformada);
      expect(dataToUtc, '31/12/2020');
    });

    test('MM/AAAA', () {
      var dataInformada = DateTime(2020, 12, 25);
      var dataToUtc = UtilData.obterDataMMAAAA(dataInformada);
      expect(dataToUtc, '12/2020');
    });

    test('DD/MM', () {
      var dataInformada = DateTime(2020, 12, 25);
      var dataToUtc = UtilData.obterDataDDMM(dataInformada);
      expect(dataToUtc, '25/12');
    });
  });

  group('Obter hora no formato', () {
    test('HH:mm:ss', () {
      var dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
      var dataToUtc = UtilData.obterHoraHHMMSS(dataInformada);
      expect(dataToUtc, '12:33:01');
    });

    test('HH:mm', () {
      var dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
      var dataToUtc = UtilData.obterHoraHHMM(dataInformada);
      expect(dataToUtc, '12:33');
    });
  });

  group('Obter DateTime', () {
    test('31/12/2022', () {
      const data = '31/12/2022';
      var dateTime = UtilData.obterDateTime(data);
      expect(dateTime, DateTime(2022, 12, 31));
    });
    test('31/12/2022 23:41:06', () {
      const data = '31/12/2022 23:41';
      var dateTime = UtilData.obterDateTimeHora(data);
      expect(dateTime, DateTime(2022, 12, 31, 23, 41, 00));
    });

    test('31/12/2022 23:41:06', () {
      const data = '23:41';
      var dateTime = UtilData.obterDateTimeHoraMinuto(data);
      expect(dateTime, DateTime(1970, 01, 01, 23, 41, 00));
    });
  });

  test('Obter CPF', () {
    ///Gerado por https://www.4devs.com.br/gerador_de_cpf
    const cpfSemMascara = '48620265083';
    const cpfComMascara = '486.202.650-83';
    expect(UtilBrasilFields.obterCpf(cpfSemMascara), cpfComMascara);
  });

  test('Obter CNPJ', () {
    ///Gerado por https://www.4devs.com.br/gerador_de_cnpj
    const cpnjSemMascara = '77343168000124';
    const cpnjComMascara = '77.343.168/0001-24';
    expect(UtilBrasilFields.obterCnpj(cpnjSemMascara), cpnjComMascara);
  });

  test('Obter CNPJ Alfanumérico', () {
    const cpnjSemMascara = 'E2X05ZR982XN04';
    const cpnjComMascara = 'E2.X05.ZR9/82XN-04';
    expect(UtilBrasilFields.obterCnpj(cpnjSemMascara), cpnjComMascara);
  });

  test('Obter inscrição CNPJ', () {
    const cpnjSemMascara = '34318733000190';
    const cpnjComMascara = '34.318.733/0001-90';
    expect(UtilBrasilFields.obterCnpjInscricao(cpnjSemMascara), '34318733');
    expect(UtilBrasilFields.obterCnpjInscricao(cpnjComMascara), '34318733');
    expect(
      UtilBrasilFields.obterCnpjInscricao(cpnjSemMascara, useFormat: true),
      '34.318.733',
    );
    expect(
      UtilBrasilFields.obterCnpjInscricao(cpnjComMascara, useFormat: true),
      '34.318.733',
    );
  });

  test('Obter inscrição CNPJ Alfanumérico', () {
    const cpnjSemMascara = 'BIK52V87H70I33';
    const cpnjComMascara = 'BI.K52.V87/H70I-33';
    expect(UtilBrasilFields.obterCnpjInscricao(cpnjSemMascara), 'BIK52V87');
    expect(UtilBrasilFields.obterCnpjInscricao(cpnjComMascara), 'BIK52V87');
    expect(
      UtilBrasilFields.obterCnpjInscricao(cpnjSemMascara, useFormat: true),
      'BI.K52.V87',
    );
    expect(
      UtilBrasilFields.obterCnpjInscricao(cpnjComMascara, useFormat: true),
      'BI.K52.V87',
    );
  });

  test('Obter Ordem do CNPJ', () {
    const cpnjSemMascara = '34318733000190';
    const cpnjComMascara = '34.318.733/0001-90';
    expect(UtilBrasilFields.obterCnpjOrdem(cpnjSemMascara), '0001');
    expect(UtilBrasilFields.obterCnpjOrdem(cpnjComMascara), '0001');
  });

  test('Obter Ordem do CNPJ Alfanumérico', () {
    const cpnjSemMascara = 'X5QK1398N10862';
    const cpnjComMascara = 'X5.QK1.398/N108-62';
    expect(UtilBrasilFields.obterCnpjOrdem(cpnjSemMascara), 'N108');
    expect(UtilBrasilFields.obterCnpjOrdem(cpnjComMascara), 'N108');
  });

  test('Obter dígitos verificadores do CNPJ', () {
    const cpnjSemMascara = '34318733000190';
    const cpnjComMascara = '34.318.733/0001-90';
    expect(UtilBrasilFields.obterCnpjDiv(cpnjSemMascara), '90');
    expect(UtilBrasilFields.obterCnpjDiv(cpnjComMascara), '90');
  });

  test('Obter dígitos verificadores do CNPJ Alfanumérico', () {
    const cpnjSemMascara = 'S653N1793ADL37';
    const cpnjComMascara = 'S6.53N.179/3ADL-37';
    expect(UtilBrasilFields.obterCnpjDiv(cpnjSemMascara), '37');
    expect(UtilBrasilFields.obterCnpjDiv(cpnjComMascara), '37');
  });

  test('Obter NUP', () {
    const nupSemMascara = '06010642120226000000';
    const nupComMascara = '0601064-21.2022.6.00.0000';
    expect(UtilBrasilFields.obterNUP(nupSemMascara), nupComMascara);
  });

  group('Obter Real', () {
    test('com moeda (R\$)', () {
      const real = 85437107.04;
      const realFormatado = 'R\$ 85.437.107,04';

      expect(UtilBrasilFields.obterReal(real), realFormatado);
    });

    test('sem moeda', () {
      const real = 85437107.04;
      const realFormatado = '85.437.107,04';

      expect(UtilBrasilFields.obterReal(real, moeda: false), realFormatado);
    });
    test('decimal: 0', () {
      const real = 85437107.04;
      const realFormatado = '85.437.107';

      expect(UtilBrasilFields.obterReal(real, moeda: false, decimal: 0),
          realFormatado);
    });
    test('decimal: 1', () {
      const real = 85437107.04;
      const realFormatado = '85.437.107,0';

      expect(UtilBrasilFields.obterReal(real, moeda: false, decimal: 1),
          realFormatado);
    });
  });

  group('Obter Real', () {
    test('negativo com moeda (R\$)', () {
      const real = -287.04;
      const realFormatado = 'R\$ -287,04';

      expect(UtilBrasilFields.obterReal(real), realFormatado);
    });

    test('negativo sem moeda', () {
      const real = -287.04;
      const realFormatado = '-287,04';

      expect(UtilBrasilFields.obterReal(real, moeda: false), realFormatado);
    });
    test('negativo decimal: 0', () {
      const real = -287.04;
      const realFormatado = '-287';

      expect(UtilBrasilFields.obterReal(real, moeda: false, decimal: 0),
          realFormatado);
    });
    test('negativo decimal: 1', () {
      const real = -287.04;
      const realFormatado = '-287,0';

      expect(UtilBrasilFields.obterReal(real, moeda: false, decimal: 1),
          realFormatado);
    });
  });

  group('Obter CEP', () {
    const cepSemPonto = '11222333';
    const cepComPonto = '11.222-333';
    test('com ponto', () {
      expect(UtilBrasilFields.obterCep(cepSemPonto), cepComPonto);
    });
    test('sem ponto', () {
      expect(UtilBrasilFields.obterCep(cepSemPonto, ponto: false), '11222-333');
    });
  });

  group('Obter Telefone', () {
    group('com DDD', () {
      test('com mascara', () {
        expect(
            UtilBrasilFields.obterTelefone('00999998877'), '(00) 99999-8877');
      });

      test('sem mascara', () {
        expect(
            UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false),
            '00999998877');
      });
    });

    group('sem DDD', () {
      test('com mascara', () {
        expect(UtilBrasilFields.obterTelefone('999998877', ddd: false),
            '99999-8877');
      });

      test('sem mascara', () {
        expect(
            UtilBrasilFields.obterTelefone('99999-8877',
                ddd: false, mascara: false),
            '999998877');
      });
    });
  });

  group('Obter Real', () {
    test('com cifrão', () {
      expect(UtilBrasilFields.obterReal(50000), r'R$ 50.000,00');
    });

    test('sem cifrão', () {
      expect(UtilBrasilFields.obterReal(50000, moeda: false), '50.000,00');
    });

    test('com cifrão e 4 casas decimais', () {
      expect(UtilBrasilFields.obterReal(50000, decimal: 4), r'R$ 50.000,0000');
    });

    test('sem cifrão e 4 casas decimais', () {
      expect(UtilBrasilFields.obterReal(50000, moeda: false, decimal: 4),
          '50.000,0000');
    });
  });

  test('obterKM', () {
    expect(UtilBrasilFields.obterKM(999), '999');
    expect(UtilBrasilFields.obterKM(1000), '1.000');
    expect(UtilBrasilFields.obterKM(10000), '10.000');
    expect(UtilBrasilFields.obterKM(100000), '100.000');
    expect(UtilBrasilFields.obterKM(999999), '999.999');
    expect(() {
      UtilBrasilFields.obterKM(9999999);
    }, throwsAssertionError);
  });

  group('Gerar CNPJ', () {
    test('formatado', () {
      final cnpj = UtilBrasilFields.gerarCNPJ(useFormat: true);
      expect(cnpj, matches(RegExp(r'\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}')));
    });

    test('não formatado', () {
      final cnpj = UtilBrasilFields.gerarCNPJ(useFormat: false);
      expect(cnpj, matches(RegExp(r'\d{14}')));
    });

    test('formatado alfanumérico', () {
      final cnpj = UtilBrasilFields.gerarCNPJ(
        useFormat: true,
        isAlphanumeric: true,
      );
      expect(cnpj, matches(RegExp(r'\w{2}\.\w{3}\.\w{3}/\w{4}-\w{2}')));
    });

    test('não formatado alfanumérico', () {
      final cnpj = UtilBrasilFields.gerarCNPJ(
        useFormat: false,
      );
      expect(cnpj, matches(RegExp(r'\w{14}')));
    });
  });
}
