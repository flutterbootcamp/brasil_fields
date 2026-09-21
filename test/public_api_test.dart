import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public entrypoint exposes utilities and numeric extensions', () {
    expect(UtilBrasilFields.removeCaracteres('12.345-6'), '123456');
    expect(UtilBrasilFields.gerarCPF(), matches(RegExp(r'^\d{11}$')));
    expect(UtilData.validarData('31/12/2024'), isTrue);
    expect(UtilData.obterDia('31/12/2024'), 31);
    expect(12.obterRealSemSimbolo(), '12,00');
    expect((12.5).obterCentavosSemSimbolo, '1250');
  });

  test('public entrypoint exposes every validator', () {
    expect(CPFValidator.isValid('334.616.710-02'), isTrue);
    expect(CNPJValidator.isValid('12.175.094/0001-19'), isTrue);
    expect(
      CnpjAlfanumericoValidator.isValid('14.890.N2J/709Y-05'),
      isTrue,
    );
    expect(NUPValidator.isValid('0601064-21.2022.6.00.0000'), isTrue);
    expect(PisPasepValidator.isValid('120.12345.67-2'), isTrue);
  });

  test('public entrypoint exposes model catalogs', () {
    expect(Estados.listaEstados, hasLength(27));
    expect(Estados.listaEstadosSigla, hasLength(27));
    final statesByAbbreviation = Map<String, String>.fromIterables(
      Estados.listaEstadosSigla,
      Estados.listaEstados,
    );
    expect(statesByAbbreviation, hasLength(27));
    expect(statesByAbbreviation['AC'], 'Acre');
    expect(statesByAbbreviation['DF'], 'Distrito Federal');
    expect(statesByAbbreviation['RJ'], 'Rio de Janeiro');
    expect(statesByAbbreviation['TO'], 'Tocantins');

    expect(Meses.mapaMeses['Janeiro'], 1);
    expect(
      Regioes.listaRegioes,
      <String>['Centro-Oeste', 'Nordeste', 'Norte', 'Sudeste', 'Sul'],
    );
    expect(Semana.mapaDiasSemanaOrdenada['Domingo'], 1);
  });
}
