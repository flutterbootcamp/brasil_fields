import 'package:brasil_fields/src/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

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
      expect(CNPJValidator.isValid(cnpj), false);
    }
  });

  test('CNPJ validator rejects malformed raw values of the exact length', () {
    const malformed = <String>[
      '12345678901A34',
      'A2345678901234',
      '1234567890123A',
      '12345678901.34',
    ];

    for (final cnpj in malformed) {
      expect(
        CNPJValidator.isValid(cnpj, stripBeforeValidation: false),
        isFalse,
        reason: cnpj,
      );
    }

    expect(
      CNPJValidator.isValid(
        '12.175.094/0001-19',
        stripBeforeValidation: false,
      ),
      isFalse,
    );
    expect(
      CNPJValidator.isValid('12175094000119', stripBeforeValidation: false),
      isTrue,
    );
    expect(CNPJValidator.isValid('12.175.094/0001-19'), isTrue);
    expect(CNPJValidator.isValid('12.175.094/0001-18'), isFalse);
  });

  test('Test CNPJ generator shape, formatting, digit domain, and checksum', () {
    final rawRandom = RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final raw = CNPJValidator.generate(random: rawRandom);
    final formattedRandom =
        RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final formatted = CNPJValidator.generate(
      useFormat: true,
      random: formattedRandom,
    );
    final expectedRaw = cnpjWithIndependentCheckDigits('012345678901');

    expect(raw, expectedRaw);
    expect(raw, matches(RegExp(r'^\d{14}$')));
    expect(formatted, matches(RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$')));
    expect(CNPJValidator.strip(formatted), raw);
    expect(CNPJValidator.format(raw), formatted);
    expect(rawRandom.requestedMaxValues, everyElement(10));
    expect(formattedRandom.requestedMaxValues, everyElement(10));
    expect(
      raw.substring(0, 12).split('').toSet(),
      containsAll(<String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']),
    );
  });

  test('CNPJ generator skips a blocklisted body before returning a valid CNPJ',
      () {
    final random = RecordingRandom(<int>[
      ...List<int>.filled(12, 0),
      9,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      0,
    ]);
    final generated = CNPJValidator.generate(random: random);
    final blocked = cnpjWithIndependentCheckDigits('000000000000');
    final expected = cnpjWithIndependentCheckDigits('901234567890');

    expect(blocked, '00000000000000');
    expect(CNPJValidator.blockList, contains(blocked));
    expect(generated, expected);
    expect(generated, matches(RegExp(r'^\d{14}$')));
    expect(CNPJValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(24));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('CNPJ generator stops after 100 blocklisted candidates', () {
    final random = RecordingRandom.constant(0);

    expect(
      () => CNPJValidator.generate(random: random),
      throwsStateError,
    );
    expect(random.requestedMaxValues, hasLength(100 * 12));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('Test CNPJ formatter', () {
    expect(CNPJValidator.format('85137090000110'), '85.137.090/0001-10');
  });

  test('Test CNPJ strip', () {
    expect(CNPJValidator.strip('85.137.090/0001-10'), '85137090000110');
  });
}
