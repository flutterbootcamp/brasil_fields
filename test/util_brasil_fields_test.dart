// @dart = 2.9
import 'package:brasil_fields/src/util/util_brasil_fields.dart';
import 'package:brasil_fields/src/util/util_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Remove caracteres', () {
    test('CPF', () {
      final cpf = '111.222.333-44';
      expect(UtilBrasilFields.removeCaracteres(cpf), '11122233344');
    });

    test('CNPJ', () {
      final cnpj = '11.222.333/4444-55';
      expect(UtilBrasilFields.removeCaracteres(cnpj), '11222333444455');
    });

    test('CEP', () {
      final cep = '11.222-333';
      expect(UtilBrasilFields.removeCaracteres(cep), '11222333');
    });

    test('Real', () {
      final real = '11.222';
      expect(UtilBrasilFields.removeCaracteres(real), '11222');
    });
    test('Real sem R\$', () {
      final real = 'R\$ 11.222';
      expect(UtilBrasilFields.removeCurrency(real), '11.222');
    });

    test('Centavos', () {
      final centavos = '0,99';
      expect(UtilBrasilFields.removeCaracteres(centavos), '099');
    });
    test('Centavos sem R\$', () {
      final centavos = 'R\$ 150,99';
      expect(UtilBrasilFields.removeCurrency(centavos), '150,99');
    });
    test('Converter moeda (R\$) em double', () {
      final centavos = 'R\$ 11.150,99';
      expect(UtilBrasilFields.convertCurrencyToDouble(centavos), 11150.99);
    });
    group('Extrair Telefone', () {
      test('Celular com ddd', () {
        final telefone = '(00) 91122-3344';
        expect(UtilBrasilFields.extrairTelefone(telefone), '00911223344');
      });
      test('Celular sem ddd', () {
        final telefone = '(00) 91122-3344';
        expect(UtilBrasilFields.extrairTelefone(telefone, ddd: false), '911223344');
      });
      test('Fixo com ddd', () {
        final telefone = '(00) 8877-6655';
        expect(UtilBrasilFields.extrairTelefone(telefone), '0088776655');
      });
      test('Fixo sem ddd', () {
        final telefone = '(99) 8877-6655';
        expect(UtilBrasilFields.extrairTelefone(telefone, ddd: false), '88776655');
      });
    });

    test('Obter DDD', () {
      final telefone = '(99) 8888-7777';
      expect(UtilBrasilFields.obterDDD(telefone), '99');
    });

    test('DATA', () {
      final data = '01/01/1900';
      expect(UtilBrasilFields.removeCaracteres(data), '01011900');
    });

    test('Hora', () {
      final hora = '23:59';
      expect(UtilBrasilFields.removeCaracteres(hora), '2359');
    });
    test('Cartao', () {
      final cartao = '1111 2222 3333 4444';
      expect(UtilBrasilFields.removeCaracteres(cartao), '1111222233334444');
    });
    test('Validade cartão', () {
      final validade = '12/23';
      expect(UtilBrasilFields.removeCaracteres(validade), '1223');
    });

    test('Altura', () {
      final altura = '1,79';
      expect(UtilBrasilFields.removeCaracteres(altura), '179');
    });

    test('Peso', () {
      final peso = '103,5';
      expect(UtilBrasilFields.removeCaracteres(peso), '1035');
    });
  });

  group('Obter data no formato', () {
    test('DD/MM/AAAA', () {
      final dataInformada = DateTime(2020, 12, 31);
      final dataToUtc = UtilData.obterDataDDMMAAAA(dataInformada);
      expect(dataToUtc, '31/12/2020');
    });

    test('MM/AAAA', () {
      final dataInformada = DateTime(2020, 12, 25);
      final dataToUtc = UtilData.obterDataMMAAAA(dataInformada);
      expect(dataToUtc, '12/2020');
    });

    test('DD/MM', () {
      final dataInformada = DateTime(2020, 12, 25);
      final dataToUtc = UtilData.obterDataDDMM(dataInformada);
      expect(dataToUtc, '25/12');
    });
  });

  group('Obter hora no formato', () {
    test('HH:mm:ss', () {
      final dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
      final dataToUtc = UtilData.obterHoraHHMMSS(dataInformada);
      expect(dataToUtc, '12:33:01');
    });

    test('HH:mm', () {
      final dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
      final dataToUtc = UtilData.obterHoraHHMM(dataInformada);
      expect(dataToUtc, '12:33');
    });
  });

  test('Obter CPF formatado', () {
    expect(UtilBrasilFields.obterCpf('11122233344'), '111.222.333-44');
  });

  test('Obter CNPJ formatado', () {
    expect(UtilBrasilFields.obterCnpj('11222333444455'), '11.222.333/4444-55');
  });

  group('Obter CEP formatado', () {
    test('com ponto', () {
      expect(UtilBrasilFields.obterCep('11222333'), '11.222-333');
    });
    test('sem ponto', () {
      expect(UtilBrasilFields.obterCep('11222333', ponto: false), '11222-333');
    });
  });

  group('Obter Telefone', () {
    group('Celular formatado', () {
      test('com DDD', () {
        expect(UtilBrasilFields.obterTelefone('00999998877'), '(00) 99999-8877');
      });

      test('sem DDD', () {
        expect(UtilBrasilFields.obterTelefone('999998877', ddd: false), '99999-8877');
      });
    });

    group('Fixo formatado', () {
      test('com DDD', () {
        expect(UtilBrasilFields.obterTelefone('0023456789'), '(00) 2345-6789');
      });
      test('sem DDD', () {
        expect(UtilBrasilFields.obterTelefone('23456789', ddd: false), '2345-6789');
      });
    });
  });
}
