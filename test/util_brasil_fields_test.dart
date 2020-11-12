import 'package:brasil_fields/src/util/util_brasil_fields.dart';
import 'package:brasil_fields/src/util/util_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CPF remove caracteres', () {
    final cpf = '111.222.333-44';
    expect(UtilBrasilFields.removeCaracteres(cpf), '11122233344');
  });

  test('CNPJ remove caracteres', () {
    final cnpj = '11.222.333/4444-55';
    expect(UtilBrasilFields.removeCaracteres(cnpj), '11222333444455');
  });

  test('CEP remove caracteres', () {
    final cep = '11.222-333';
    expect(UtilBrasilFields.removeCaracteres(cep), '11222333');
  });

  test('REAL remove caracteres', () {
    final real = '11.222';
    expect(UtilBrasilFields.removeCaracteres(real), '11222');
  });

  test('CENTAVOS remove caracteres', () {
    final centavos = '0,99';
    expect(UtilBrasilFields.removeCaracteres(centavos), '099');
  });

  test('TELEFONE remove caracteres', () {
    final telefone = '(99) 88888-7777';

    expect(UtilBrasilFields.removeCaracteres(telefone), '99888887777');
  });

  test('DATA remove caracteres', () {
    final data = '01/01/1900';
    expect(UtilBrasilFields.removeCaracteres(data), '01011900');
  });

  test('Hora remove caracteres', () {
    final hora = '23:59';
    expect(UtilBrasilFields.removeCaracteres(hora), '2359');
  });
  test('Cartao remove caracteres', () {
    final cartao = '1111 2222 3333 4444';
    expect(UtilBrasilFields.removeCaracteres(cartao), '1111222233334444');
  });
  test('Validade cartão remove caracteres', () {
    final validade = '12/23';
    expect(UtilBrasilFields.removeCaracteres(validade), '1223');
  });

  test('Altura remove caracteres', () {
    final altura = '1,79';
    expect(UtilBrasilFields.removeCaracteres(altura), '179');
  });

  test('Peso remove caracteres', () {
    final peso = '103,5';
    expect(UtilBrasilFields.removeCaracteres(peso), '1035');
  });

  test('Obter data no formato DD/MM/AAAA', () {
    final dataInformada = DateTime(2020, 12, 31);
    final dataToUtc = UtilData.obterDataDDMMAAAA(dataInformada);
    expect(dataToUtc, '31/12/2020');
  });

  test('Obter data no formato MM/AAAA', () {
    final dataInformada = DateTime(2020, 12, 25);
    final dataToUtc = UtilData.obterDataMMAAAA(dataInformada);
    expect(dataToUtc, '12/2020');
  });

  test('Obter data no formato DD/MM', () {
    final dataInformada = DateTime(2020, 12, 25);
    final dataToUtc = UtilData.obterDataDDMM(dataInformada);
    expect(dataToUtc, '25/12');
  });

  test('Obter data no formato DD/MM', () {
    final dataInformada = DateTime(2020, 12, 25);
    final dataToUtc = UtilData.obterDataMMAAAA(dataInformada);
    expect(dataToUtc, '12/2020');
  });

  test('Obter hora no formato HH:mm:ss', () {
    final dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
    final dataToUtc = UtilData.obterHoraHHMMSS(dataInformada);
    expect(dataToUtc, '12:33:01');
  });

  test('Obter hora no formato HH:mm', () {
    final dataInformada = DateTime(2020, 12, 31, 12, 33, 01);
    final dataToUtc = UtilData.obterHoraHHMM(dataInformada);
    expect(dataToUtc, '12:33');
  });

  test('Obter CPF formatado', () {
    expect(UtilBrasilFields.obterCpf('11122233344'), '111.222.333-44');
  });

  test('Obter CNPJ formatado', () {
    expect(UtilBrasilFields.obterCnpj('11222333444455'), '11.222.333/4444-55');
  });
  test('Obter CEP formatado', () {
    expect(UtilBrasilFields.obterCep('11222333'), '11.222-333');
    expect(UtilBrasilFields.obterCep('11222333', ponto: false), '11222-333');
  });

  test('Obter Telefone formatado', () {
    expect(UtilBrasilFields.obterTelefone('00999998877'), '(00) 99999-8877');
    expect(
        UtilBrasilFields.obterTelefone('999998877', ddd: false), '99999-8877');
  });
}
