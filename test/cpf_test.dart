import 'package:brasil_fields/src/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

void main() {
  test('Test CPF validator', () {
    expect(CPFValidator.isValid('334.616.710-02'), true);
    expect(CPFValidator.isValid('334.616.710-01'), false);
    expect(CPFValidator.isValid('35999906032'), true);
    expect(CPFValidator.isValid('35999906031'), false);
    expect(CPFValidator.isValid('033461671002'), false);
    expect(
        CPFValidator.isValid('03346teste1671002@mail',
            stripBeforeValidation: false),
        false);
    expect(
        CPFValidator.isValid('57abc803.6586-52', stripBeforeValidation: false),
        false);
    expect(CPFValidator.isValid('03.3461.67100-2'), false);

    final blockList = <String>[
      '00000000000',
      '11111111111',
      '22222222222',
      '33333333333',
      '44444444444',
      '55555555555',
      '66666666666',
      '77777777777',
      '88888888888',
      '99999999999',
      '12345678909'
    ];

    for (var cpf in blockList) {
      expect(CPFValidator.isValid(cpf), false);
    }
  });

  test('CPF validator rejects malformed raw values of the exact length', () {
    const malformed = <String>[
      '12345678A09',
      'A2345678909',
      '1234567890A',
      '12345.78909',
    ];

    for (final cpf in malformed) {
      expect(
        CPFValidator.isValid(cpf, stripBeforeValidation: false),
        isFalse,
        reason: cpf,
      );
    }

    expect(
      CPFValidator.isValid(
        '334.616.710-02',
        stripBeforeValidation: false,
      ),
      isFalse,
    );
    expect(
      CPFValidator.isValid('33461671002', stripBeforeValidation: false),
      isTrue,
    );
    expect(CPFValidator.isValid('334.616.710-02'), isTrue);
    expect(CPFValidator.isValid('334.616.710-01'), isFalse);
  });

  test('Test CPF generator shape, formatting, digit domain, and checksum', () {
    final rawRandom = RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    final firstRaw = CPFValidator.generate(random: rawRandom);
    final secondRaw = CPFValidator.generate(random: rawRandom);
    final formattedRandom = RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8]);
    final formatted = CPFValidator.generate(
      useFormat: true,
      random: formattedRandom,
    );

    expect(firstRaw, cpfWithIndependentCheckDigits('012345678'));
    expect(secondRaw, cpfWithIndependentCheckDigits('901234567'));
    expect(firstRaw, matches(RegExp(r'^\d{11}$')));
    expect(secondRaw, matches(RegExp(r'^\d{11}$')));
    expect(formatted, matches(RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')));
    expect(CPFValidator.strip(formatted), firstRaw);
    expect(CPFValidator.format(firstRaw), formatted);

    expect(rawRandom.requestedMaxValues, everyElement(10));
    expect(formattedRandom.requestedMaxValues, everyElement(10));
    expect(
      '${firstRaw.substring(0, 9)}${secondRaw.substring(0, 9)}'
          .split('')
          .toSet(),
      containsAll(<String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']),
    );
  });

  test('CPF generator skips a blocklisted body before returning a valid CPF',
      () {
    final random = RecordingRandom(<int>[
      ...List<int>.filled(9, 0),
      9,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
    ]);
    final generated = CPFValidator.generate(random: random);
    final blocked = cpfWithIndependentCheckDigits('000000000');
    final expected = cpfWithIndependentCheckDigits('901234567');

    expect(blocked, '00000000000');
    expect(CPFValidator.blockList, contains(blocked));
    expect(generated, expected);
    expect(generated, matches(RegExp(r'^\d{11}$')));
    expect(CPFValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(18));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('CPF generator stops after 100 blocklisted candidates', () {
    final random = RecordingRandom.constant(0);

    expect(
      () => CPFValidator.generate(random: random),
      throwsStateError,
    );
    expect(random.requestedMaxValues, hasLength(100 * 9));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('Test CPF formatter', () {
    expect(CPFValidator.format('33461671002'), '334.616.710-02');
  });

  test('Test CPF strip', () {
    expect(CPFValidator.strip('334.616.710-02'), '33461671002');
  });
}
