import 'package:brasil_fields/src/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test CNPJ validator', () {
    expect(CNPJValidator.isValid('12.175.094/0001-19'), true);
    expect(CNPJValidator.isValid('12.175.094/0001-18'), false);
    expect(CNPJValidator.isValid('17942159000128'), true);
    expect(
      CNPJValidator.isValid(
        '17942159000128@mail.com',
        stripBeforeValidation: false,
      ),
      false,
    );
    expect(
      CNPJValidator.isValid('17942159000128', stripBeforeValidation: false),
      true,
    );
    expect(CNPJValidator.isValid('17942159000127'), false);
    expect(CNPJValidator.isValid('017942159000128'), false);
    expect(CNPJValidator.isValid('14.890.N2J/709Y-05'), true);
    expect(CNPJValidator.isValid('HW487OK5W20A70'), true);
    expect(CNPJValidator.isValid('14.890.N2J/709Y-00'), false);
    expect(CNPJValidator.isValid('HW487OK5W20A00'), false);

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
      expect(CNPJValidator.isValid(cnpj), false);
    }
  });

  test('Test CNPJ generator', () {
    for (var i = 0; i < 10; i++) {
      var raw = CNPJValidator.generate();
      var formatted = CNPJValidator.generate(useFormat: true);

      expect(raw != formatted, true);
      expect(CNPJValidator.isValid(raw), true);
      expect(CNPJValidator.isValid(formatted), true);
    }
  });

  test('Test CNPJ formatter', () {
    expect(CNPJValidator.format('85137090000110'), '85.137.090/0001-10');
    expect(CNPJValidator.format('75C6BSBV34PT38'), '75.C6B.SBV/34PT-38');
    expect(CNPJValidator.format('HI33314I4Y0066'), 'HI.333.14I/4Y00-66');
  });

  test('Test CNPJ strip', () {
    expect(CNPJValidator.strip('85.137.090/0001-10'), '85137090000110');
    expect(CNPJValidator.strip('8H.31X.0XY/0494-59'), '8H31X0XY049459');
    expect(CNPJValidator.strip('15.MHL.1E9/A4XS-19'), '15MHL1E9A4XS19');
  });
}
