import 'package:brasil_fields/src/validators/cnpj_alfanumerico_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test CNPJ validator', () {
    expect(CnpjAlfanumericoValidator.isValid('12.175.094/0001-19'), true);
    expect(CnpjAlfanumericoValidator.isValid('12.175.094/0001-18'), false);
    expect(CnpjAlfanumericoValidator.isValid('17942159000128'), true);
    expect(
      CnpjAlfanumericoValidator.isValid(
        '17942159000128@mail.com',
        stripBeforeValidation: false,
      ),
      false,
    );
    expect(
      CnpjAlfanumericoValidator.isValid('17942159000128',
          stripBeforeValidation: false),
      true,
    );
    expect(CnpjAlfanumericoValidator.isValid('17942159000127'), false);
    expect(CnpjAlfanumericoValidator.isValid('017942159000128'), false);
    expect(CnpjAlfanumericoValidator.isValid('14.890.N2J/709Y-05'), true);
    expect(CnpjAlfanumericoValidator.isValid('HW487OK5W20A70'), true);
    expect(CnpjAlfanumericoValidator.isValid('14.890.N2J/709Y-00'), false);
    expect(CnpjAlfanumericoValidator.isValid('HW487OK5W20A00'), false);

    var blackListed = <String>[
      '00000000000000',
      '11111111111111',
      '22222222222222',
      '33333333333333',
      '44444444444444',
      '55555555555555',
      '66666666666666',
      '77777777777777',
      '88888888888888',
      '99999999999999'
    ];

    for (var cnpj in blackListed) {
      expect(CnpjAlfanumericoValidator.isValid(cnpj), false);
    }
  });

  test('Test CNPJ generator', () {
    for (var i = 0; i < 10; i++) {
      var raw = CnpjAlfanumericoValidator.generate();
      var formatted = CnpjAlfanumericoValidator.generate(useFormat: true);

      expect(raw != formatted, true);
      expect(CnpjAlfanumericoValidator.isValid(raw), true);
      expect(CnpjAlfanumericoValidator.isValid(formatted), true);
    }
  });

  test('Test CNPJ formatter', () {
    expect(CnpjAlfanumericoValidator.format('85137090000110'),
        '85.137.090/0001-10');
    expect(CnpjAlfanumericoValidator.format('75C6BSBV34PT38'),
        '75.C6B.SBV/34PT-38');
    expect(CnpjAlfanumericoValidator.format('HI33314I4Y0066'),
        'HI.333.14I/4Y00-66');
  });

  test('Test CNPJ strip', () {
    expect(CnpjAlfanumericoValidator.strip('85.137.090/0001-10'),
        '85137090000110');
    expect(CnpjAlfanumericoValidator.strip('8H.31X.0XY/0494-59'),
        '8H31X0XY049459');
    expect(CnpjAlfanumericoValidator.strip('15.MHL.1E9/A4XS-19'),
        '15MHL1E9A4XS19');
  });
}
