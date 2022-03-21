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
      expect(UtilBrasilFields.removeCaracteres(cnpj), '11222333444455');
    });

    test('CEP', () {
      const cep = '11.222-333';
      expect(UtilBrasilFields.removeCaracteres(cep), '11222333');
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

    test('Obter DDD', () {
      const telefone = '(99) 8888-7777';
      expect(UtilBrasilFields.obterDDD(telefone), '99');
    });

    test('DATA', () {
      const data = '01/01/1900';
      expect(UtilBrasilFields.removeCaracteres(data), '01011900');
    });

    test('Hora', () {
      const hora = '23:59';
      expect(UtilBrasilFields.removeCaracteres(hora), '2359');
    });
    test('Cartao', () {
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
}
