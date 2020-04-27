import 'package:brasil_fields/util/util_brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CPF remove caracteres', () {
    final data = '111.222.333-44';
    expect(UtilBrasilFields.removeCaracteres(data), '11122233344');
  });

  test('CNPJ remove caracteres', () {
    final data = '11.222.333/4444-55';
    expect(UtilBrasilFields.removeCaracteres(data), '11222333444455');
  });

  test('CEP remove caracteres', () {
    final data = '11.222-333';
    expect(UtilBrasilFields.removeCaracteres(data), '11222333');
  });

  test('REAL remove caracteres', () {
    final data = '11.222';
    expect(UtilBrasilFields.removeCaracteres(data), '11222');
  });

  test('CENTAVOS remove caracteres', () {
    final data = '0,99';
    expect(UtilBrasilFields.removeCaracteres(data), '099');
  });

  test('TELEFONE remove caracteres', () {
    final data = '(99) 88888-7777';

    expect(UtilBrasilFields.removeCaracteres(data), '99888887777');
  });

  test('DATA remove caracteres', () {
    final data = '01/01/1900';
    expect(UtilBrasilFields.removeCaracteres(data), '01011900');
  });

  test('Hora remove caracteres', () {
    final data = '23:59';
    expect(UtilBrasilFields.removeCaracteres(data), '2359');
  });
}
