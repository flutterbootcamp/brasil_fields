import 'package:brasil_fields/src/validators/cnpj_alfanumerico_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

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

    final blackListed = <String>[
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

  test('alphanumeric CNPJ rejects forbidden raw characters and positions', () {
    const malformed = <String>[
      '12345678901@83',
      '!!!!!!!!!!!!14',
      'a2345678901234',
      '12345_78901234',
      'HW487OK5W20A7A',
    ];

    for (final cnpj in malformed) {
      expect(
        CnpjAlfanumericoValidator.isValid(
          cnpj,
          stripBeforeValidation: false,
        ),
        isFalse,
        reason: cnpj,
      );
    }

    expect(
      CnpjAlfanumericoValidator.isValid(
        '14.890.N2J/709Y-05',
        stripBeforeValidation: false,
      ),
      isFalse,
    );
    expect(
      CnpjAlfanumericoValidator.isValid(
        '14890N2J709Y05',
        stripBeforeValidation: false,
      ),
      isTrue,
    );
    expect(CnpjAlfanumericoValidator.isValid('14.890.N2J/709Y-05'), isTrue);
  });

  test('Test alphanumeric CNPJ generator shape, formatting, and checksum', () {
    final rawRandom = RecordingRandom(<int>[
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
    ]);
    final raw = CnpjAlfanumericoValidator.generate(random: rawRandom);
    final formattedRandom = RecordingRandom(<int>[
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
    ]);
    final formatted = CnpjAlfanumericoValidator.generate(
      useFormat: true,
      random: formattedRandom,
    );
    final expectedRaw = cnpjWithIndependentCheckDigits('ABCDEFGHIJKL');
    final rawShape = RegExp(r'^[A-Z0-9]{12}[0-9]{2}$');
    final formattedShape =
        RegExp(r'^[A-Z0-9]{2}\.[A-Z0-9]{3}\.[A-Z0-9]{3}/[A-Z0-9]{4}-[0-9]{2}$');

    expect(raw, expectedRaw);
    expect(raw, matches(rawShape));
    expect(formatted, matches(formattedShape));
    expect(CnpjAlfanumericoValidator.strip(formatted), raw);
    expect(CnpjAlfanumericoValidator.format(raw), formatted);
    expect(rawRandom.requestedMaxValues, everyElement(36));
    expect(formattedRandom.requestedMaxValues, everyElement(36));

    expect(rawShape.hasMatch('${raw}X'), isFalse);
    expect(rawShape.hasMatch('X$raw'), isFalse);
    expect(rawShape.hasMatch(raw.replaceFirst('A', '_')), isFalse);
    expect(rawShape.hasMatch(raw.toLowerCase()), isFalse);
    expect(rawShape.hasMatch('${raw.substring(0, 13)}A'), isFalse);
  });

  test(
      'alphanumeric CNPJ generator skips a blocklisted body before a valid CNPJ',
      () {
    final random = RecordingRandom(<int>[
      ...List<int>.filled(12, 0),
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
    ]);
    final generated = CnpjAlfanumericoValidator.generate(random: random);
    final blocked = cnpjWithIndependentCheckDigits('000000000000');
    final expected = cnpjWithIndependentCheckDigits('ABCDEFGHIJKL');

    expect(blocked, '00000000000000');
    expect(CnpjAlfanumericoValidator.blockList, contains(blocked));
    expect(generated, expected);
    expect(generated, matches(RegExp(r'^[A-Z0-9]{12}[0-9]{2}$')));
    expect(CnpjAlfanumericoValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(24));
    expect(random.requestedMaxValues, everyElement(36));
  });

  test('alphanumeric CNPJ generator stops after 100 blocked candidates', () {
    final random = RecordingRandom.constant(0);

    expect(
      () => CnpjAlfanumericoValidator.generate(random: random),
      throwsStateError,
    );
    expect(random.requestedMaxValues, hasLength(100 * 12));
    expect(random.requestedMaxValues, everyElement(36));
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
