import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test PIS/PASEP validator', () {
    expect(PisPasepValidator.isValid('120.12345.67-2'), true);
    expect(PisPasepValidator.isValid('12012345672'), true);
    expect(PisPasepValidator.isValid('120.65432.10-3'), true);
    expect(PisPasepValidator.isValid('12345678900'), true);

    // dígito verificador incorreto
    expect(PisPasepValidator.isValid('12012345673'), false);
    expect(PisPasepValidator.isValid('120.12345.67-3'), false);

    // tamanho inválido
    expect(PisPasepValidator.isValid('1201234567'), false);
    expect(PisPasepValidator.isValid('120123456722'), false);

    // valores vazios ou nulos
    expect(PisPasepValidator.isValid(null), false);
    expect(PisPasepValidator.isValid(''), false);

    // dígitos repetidos
    expect(PisPasepValidator.isValid('00000000000'), false);
    expect(PisPasepValidator.isValid('11111111111'), false);
    expect(PisPasepValidator.isValid('99999999999'), false);

    // sem remover a máscara antes de validar
    expect(
      PisPasepValidator.isValid('120.12345.67-2', stripBeforeValidation: false),
      false,
    );
    expect(
      PisPasepValidator.isValid('12012345672', stripBeforeValidation: false),
      true,
    );
    expect(
      PisPasepValidator.isValid('120abc45672', stripBeforeValidation: false),
      false,
    );
  });

  test('Test PIS/PASEP formatter', () {
    expect(PisPasepValidator.format('12012345672'), '120.12345.67-2');
    expect(PisPasepValidator.format('120.12345.67-2'), '120.12345.67-2');
  });

  test('Test PIS/PASEP strip', () {
    expect(PisPasepValidator.strip('120.12345.67-2'), '12012345672');
    expect(PisPasepValidator.strip(null), '');
  });

  test('Test PIS/PASEP generate', () {
    for (var i = 0; i < 100; i++) {
      final pis = PisPasepValidator.generate();

      expect(pis.length, 11);
      expect(PisPasepValidator.isValid(pis), true);
    }

    final pisFormatado = PisPasepValidator.generate(useFormat: true);

    expect(pisFormatado.length, 14);
    expect(PisPasepValidator.isValid(pisFormatado), true);
  });
}
