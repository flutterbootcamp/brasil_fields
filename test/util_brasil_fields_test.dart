import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

void main() {
  group('Remove caracteres', () {
    test('CNPJ', () {
      const cnpj = '11.222.333/4444-55';
      const cnpj2 = 'U7.YHQ.1HJ/1MQY-56';
      expect(UtilBrasilFields.removeCaracteres(cnpj), '11222333444455');
      expect(UtilBrasilFields.removeCaracteres(cnpj2), 'U7YHQ1HJ1MQY56');
    });

    test('Converter moeda aceita espaços comum e não separável', () {
      expect(UtilBrasilFields.converterMoedaParaDouble(r'R$ 1.590,90'), 1590.9);
      expect(
        UtilBrasilFields.converterMoedaParaDouble('R\$\u00a01.590,90'),
        1590.9,
      );
      expect(
        UtilBrasilFields.converterMoedaParaDouble('-R\$\u00a01.590,90'),
        -1590.9,
      );
      expect(UtilBrasilFields.removerSimboloMoeda(r'R$ 1.590,90'), '1.590,90');
      expect(
        UtilBrasilFields.removerSimboloMoeda('R\$\u00a01.590,90'),
        '1.590,90',
      );
      expect(
        UtilBrasilFields.removerSimboloMoeda('-R\$\u00a01.590,90'),
        '-1.590,90',
      );
    });
    test('Obter centavos arredonda valores monetários de duas casas', () {
      const expected = <(double, String)>[
        (0.29, '29'),
        (0.57, '57'),
        (1.13, '113'),
        (-0.29, '-29'),
        (-0.57, '-57'),
        (-1.13, '-113'),
        (0, '0'),
        (1, '100'),
      ];

      for (final entry in expected) {
        expect(
          entry.$1.obterCentavosSemSimbolo,
          entry.$2,
          reason: entry.$1.toString(),
        );
        final symbol = entry.$1.isNegative ? '-R\$ ' : 'R\$ ';
        expect(
          entry.$1.obterCentavos,
          '$symbol${entry.$2.replaceFirst('-', '')}',
          reason: entry.$1.toString(),
        );
      }
    });
    test('Obter centavos arredonda frações para o centavo mais próximo', () {
      expect((0.294).obterCentavosSemSimbolo, '29');
      expect((0.296).obterCentavosSemSimbolo, '30');
      expect((-0.294).obterCentavosSemSimbolo, '-29');
      expect((-0.296).obterCentavosSemSimbolo, '-30');
    });
    test('Valores formatados fazem round trip na precisão exibida', () {
      const values = <double>[0, 0.29, 60, 999.99, 1000, 1000.01, -1590.9];

      for (final value in values) {
        expect(
          UtilBrasilFields.converterMoedaParaDouble(value.obterReal()),
          closeTo(value, 0.0000001),
          reason: 'extensão: $value',
        );
        expect(
          UtilBrasilFields.converterMoedaParaDouble(
            UtilBrasilFields.obterReal(value),
          ),
          closeTo(value, 0.0000001),
          reason: 'utilitário: $value',
        );
      }

      expect((999.99).obterReal(), 'R\$\u00a0999,99');
      expect((1000.0).obterReal(), 'R\$\u00a01.000,00');
      expect(UtilBrasilFields.obterReal(999.99), r'R$ 999,99');
      expect(UtilBrasilFields.obterReal(1000), r'R$ 1.000,00');
    });
    test('Obter real de um double', () {
      const double valor = 1590.9;
      final String valorConvertido = valor.obterReal();
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}1.590,90');
    });
    test(
      'Obter real sem símbolo de um double onde o valor é menor que 100',
      () {
        const double valor = 60.0;
        final String valorConvertido = valor.obterRealSemSimbolo();
        expect(valorConvertido, '60,00');
      },
    );
    test(
        'Obter real com tres casas decimais sem símbolo, proveniente de um double',
        () {
      const double valor = 2563.55;
      final String valorConvertido = valor.obterRealSemSimbolo(3);
      expect(valorConvertido, '2.563,550');
    });
    test('Obter real com tres casas decimais de um double', () {
      const double valor = 560.9;
      final String valorConvertido = valor.obterReal(3);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}560,900');
    });
    test(
      'Obter real com tres casas decimais e valor negativo de um double',
      () {
        const double valor = -560.9;
        final String valorConvertido = valor.obterReal(3);
        expect(valorConvertido, '-R\$${String.fromCharCode(160)}560,900');
      },
    );
    test('Obter real com duas casas decimais de um inteiro', () {
      const int valor = 350000;
      final String valorConvertido = valor.obterReal(2);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}350.000,00');
    });
    test('Obter real com tres casas decimais de um inteiro', () {
      const int valor = 560;
      final String valorConvertido = valor.obterReal(3);
      expect(valorConvertido, 'R\$${String.fromCharCode(160)}560,000');
    });
    test(
        'Obter centavos com tres casas decimais e sem símbolo de real de um inteiro',
        () {
      const int valor = 560;
      final String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '56000');
    });
    test('Obter centavos de um inteiro negativo sem símbolo de real', () {
      const int valor = -105;
      final String valorConvertido = valor.obterCentavosSemSimbolo;
      expect(valorConvertido, '-10500');
    });
    test('Obter real de um inteiro negativo sem símbolo de real', () {
      const int valor = -10900;
      final String valorConvertido = valor.obterRealSemSimbolo(3);
      expect(valorConvertido, '-10.900,000');
    });
    test('Obter DDD', () {
      const telefone = '(99) 8888-7777';
      expect(UtilBrasilFields.obterDDD(telefone), '99');
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

  group('UtilData helpers', () {
    test('remove caracteres de datas cruas e formatadas', () {
      expect(UtilData.removeCaracteres('31122024'), '31122024');
      expect(UtilData.removeCaracteres('31/12/2024'), '31122024');
      expect(UtilData.removeCaracteres('data: 01-02-2023'), '01022023');
      expect(UtilData.removeCaracteres('sem data'), isEmpty);
    });

    test('valida o formato pela quantidade de dígitos', () {
      expect(UtilData.validarData('01012000'), isTrue);
      expect(UtilData.validarData('31/12/2024'), isTrue);
      expect(UtilData.validarData('99/99/9999'), isTrue);
      expect(UtilData.validarData('1/12/2024'), isFalse);
      expect(UtilData.validarData('31/12/24'), isFalse);
      expect(UtilData.validarData(''), isFalse);
    });

    test('obtém dia e mês de várias datas', () {
      const expectedParts = <String, (int, int)>{
        '01/01/1900': (1, 1),
        '29022024': (29, 2),
        '31-12-2099': (31, 12),
        '00/00/0000': (0, 0),
      };

      for (final entry in expectedParts.entries) {
        expect(UtilData.obterDia(entry.key), entry.value.$1, reason: entry.key);
        expect(UtilData.obterMes(entry.key), entry.value.$2, reason: entry.key);
      }
    });

    test('dia e mês rejeitam comprimentos inválidos', () {
      for (final value in <String>['', '010120', '001012024']) {
        expect(() => UtilData.obterDia(value), throwsException, reason: value);
        expect(() => UtilData.obterMes(value), throwsException, reason: value);
      }
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

  group('Obter DateTime', () {
    test('31/12/2022', () {
      const data = '31/12/2022';
      final dateTime = UtilData.obterDateTime(data);
      expect(dateTime, DateTime(2022, 12, 31));
    });
    test('31/12/2022 23:41:06', () {
      const data = '31/12/2022 23:41';
      final dateTime = UtilData.obterDateTimeHora(data);
      expect(dateTime, DateTime(2022, 12, 31, 23, 41, 00));
    });

    test('31/12/2022 23:41:06', () {
      const data = '23:41';
      final dateTime = UtilData.obterDateTimeHoraMinuto(data);
      expect(dateTime, DateTime(1970, 01, 01, 23, 41, 00));
    });
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

  group('Validadores públicos', () {
    test('CPF cobre valores válidos, inválidos e nulos', () {
      expect(UtilBrasilFields.isCPFValido('334.616.710-02'), isTrue);
      expect(UtilBrasilFields.isCPFValido('334.616.710-01'), isFalse);
      expect(UtilBrasilFields.isCPFValido(null), isFalse);
    });

    test('CNPJ encaminha para o validador solicitado', () {
      expect(UtilBrasilFields.isCNPJValido('12.175.094/0001-19'), isTrue);
      expect(UtilBrasilFields.isCNPJValido('12.175.094/0001-18'), isFalse);
      expect(UtilBrasilFields.isCNPJValido(null), isFalse);
      expect(
        UtilBrasilFields.isCNPJValido(
          '14.890.N2J/709Y-05',
          isAlphanumeric: true,
        ),
        isTrue,
      );
      expect(
        UtilBrasilFields.isCNPJValido('14.890.N2J/709Y-05'),
        isFalse,
      );
    });

    test('NUP cobre valores válidos, inválidos e nulos', () {
      expect(
        UtilBrasilFields.isNUPValido('0601064-21.2022.6.00.0000'),
        isTrue,
      );
      expect(
        UtilBrasilFields.isNUPValido('0601064-22.2022.6.00.0000'),
        isFalse,
      );
      expect(UtilBrasilFields.isNUPValido(null), isFalse);
    });

    test('PIS/PASEP cobre valores válidos, inválidos e nulos', () {
      expect(UtilBrasilFields.isPisPasepValido('120.12345.67-2'), isTrue);
      expect(UtilBrasilFields.isPisPasepValido('120.12345.67-3'), isFalse);
      expect(UtilBrasilFields.isPisPasepValido(null), isFalse);
    });
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

      expect(
        UtilBrasilFields.obterReal(real, moeda: false, decimal: 0),
        realFormatado,
      );
    });
    test('decimal: 1', () {
      const real = 85437107.04;
      const realFormatado = '85.437.107,0';

      expect(
        UtilBrasilFields.obterReal(real, moeda: false, decimal: 1),
        realFormatado,
      );
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

      expect(
        UtilBrasilFields.obterReal(real, moeda: false, decimal: 0),
        realFormatado,
      );
    });
    test('negativo decimal: 1', () {
      const real = -287.04;
      const realFormatado = '-287,0';

      expect(
        UtilBrasilFields.obterReal(real, moeda: false, decimal: 1),
        realFormatado,
      );
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
          UtilBrasilFields.obterTelefone('00999998877'),
          '(00) 99999-8877',
        );
      });

      test('sem mascara', () {
        expect(
          UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false),
          '00999998877',
        );
      });
    });

    group('sem DDD', () {
      test('com mascara', () {
        expect(
          UtilBrasilFields.obterTelefone('999998877', ddd: false),
          '99999-8877',
        );
      });

      test('sem mascara', () {
        expect(
          UtilBrasilFields.obterTelefone(
            '99999-8877',
            ddd: false,
            mascara: false,
          ),
          '999998877',
        );
      });
    });
  });

  group('Obter Real', () {
    test('com cifrão e 4 casas decimais', () {
      expect(UtilBrasilFields.obterReal(50000, decimal: 4), r'R$ 50.000,0000');
    });

    test('sem cifrão e 4 casas decimais', () {
      expect(
        UtilBrasilFields.obterReal(50000, moeda: false, decimal: 4),
        '50.000,0000',
      );
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
    }, throwsArgumentError);
  });

  group('Geradores públicos', () {
    test('exemplos de CPF usam parâmetros nomeados e defaults crus', () {
      final defaultCpf = UtilBrasilFields.gerarCPF();
      final explicitRaw = UtilBrasilFields.gerarCPF(
        useFormat: false,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7]),
      );
      final formatted = UtilBrasilFields.gerarCPF(
        useFormat: true,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7]),
      );
      final expectedRaw = cpfWithIndependentCheckDigits('901234567');

      expect(defaultCpf, matches(RegExp(r'^\d{11}$')));
      expect(explicitRaw, expectedRaw);
      expect(formatted, CPFValidator.format(expectedRaw));
      expect(formatted, matches(RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')));
    });

    test('PIS/PASEP usa parâmetros nomeados e defaults crus', () {
      final defaultPis = UtilBrasilFields.gerarPisPasep();
      final explicitRaw = UtilBrasilFields.gerarPisPasep(
        useFormat: false,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7, 8]),
      );
      final formatted = UtilBrasilFields.gerarPisPasep(
        useFormat: true,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7, 8]),
      );

      expect(defaultPis, matches(RegExp(r'^\d{11}$')));
      expect(explicitRaw, '90123456784');
      expect(formatted, '901.23456.78-4');
      expect(UtilBrasilFields.isPisPasepValido(explicitRaw), isTrue);
    });

    test('exemplos de CNPJ usam parâmetros nomeados e defaults crus', () {
      final defaultCnpj = UtilBrasilFields.gerarCNPJ();
      final explicitRaw = UtilBrasilFields.gerarCNPJ(
        useFormat: false,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7, 8]),
      );
      final formatted = UtilBrasilFields.gerarCNPJ(
        useFormat: true,
        random: RecordingRandom(<int>[9, 0, 1, 2, 3, 4, 5, 6, 7, 8]),
      );
      final expectedRaw = cnpjWithIndependentCheckDigits('901234567890');

      expect(defaultCnpj, matches(RegExp(r'^\d{14}$')));
      expect(explicitRaw, expectedRaw);
      expect(formatted, CNPJValidator.format(expectedRaw));
      expect(
        formatted,
        matches(RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$')),
      );
    });

    test('CNPJ alfanumérico usa a rota solicitada nos dois formatos', () {
      final raw = UtilBrasilFields.gerarCNPJ(
        isAlphanumeric: true,
        random: RecordingRandom(<int>[
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
        ]),
      );
      final formatted = UtilBrasilFields.gerarCNPJ(
        useFormat: true,
        isAlphanumeric: true,
        random: RecordingRandom(<int>[
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
        ]),
      );
      final expectedRaw = cnpjWithIndependentCheckDigits('ABCDEFGHIJKL');

      expect(raw, expectedRaw);
      expect(raw, matches(RegExp(r'^[A-Z0-9]{12}[0-9]{2}$')));
      expect(formatted, CnpjAlfanumericoValidator.format(expectedRaw));
      expect(
        formatted,
        matches(
          RegExp(
            r'^[A-Z0-9]{2}\.[A-Z0-9]{3}\.[A-Z0-9]{3}/[A-Z0-9]{4}-[0-9]{2}$',
          ),
        ),
      );
    });
  });
}
