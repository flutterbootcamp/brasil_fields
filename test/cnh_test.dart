import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

void main() {
  test('Test CNH validator', () {
    expect(CNHValidator.isValid('18718682003'), true);
    expect(CNHValidator.isValid('40673094272'), true);
    expect(CNHValidator.isValid('97028218846'), true);
    expect(CNHValidator.isValid('56220269750'), true);

    // Dígitos verificadores incorretos.
    expect(CNHValidator.isValid('18718682004'), false);
    expect(CNHValidator.isValid('18718682013'), false);

    // Tamanho inválido.
    expect(CNHValidator.isValid('1871868200'), false);
    expect(CNHValidator.isValid('187186820033'), false);

    // Valores vazios ou nulos.
    expect(CNHValidator.isValid(null), false);
    expect(CNHValidator.isValid(''), false);

    // Dígitos repetidos.
    expect(CNHValidator.isValid('00000000000'), false);
    expect(CNHValidator.isValid('11111111111'), false);
    expect(CNHValidator.isValid('99999999999'), false);

    // Validação sem remover os separadores.
    expect(
      CNHValidator.isValid('187.186.820-03', stripBeforeValidation: false),
      false,
    );
    expect(
      CNHValidator.isValid('18718682003', stripBeforeValidation: false),
      true,
    );
  });

  test('CNH validator rejects malformed raw values of the exact length', () {
    const malformed = <String>[
      '1871868200A',
      'A8718682003',
      '187186820-3',
      '187.18682003',
    ];

    for (final cnh in malformed) {
      expect(
        CNHValidator.isValid(cnh, stripBeforeValidation: false),
        isFalse,
        reason: cnh,
      );
    }
  });

  test('CNH validator rejects every repeated-digit sequence', () {
    for (var digit = 0; digit <= 9; digit++) {
      final repeated = digit.toString() * 11;

      // A lista de bloqueio é necessária: as sequências repetidas satisfazem
      // o cálculo dos dígitos verificadores.
      expect(cnhWithIndependentCheckDigits(digit.toString() * 9), repeated);
      expect(CNHValidator.blockList, contains(repeated));
      expect(CNHValidator.isValid(repeated), isFalse, reason: repeated);
    }
  });

  test('Test CNH strip', () {
    expect(CNHValidator.strip('187.186.820-03'), '18718682003');
    expect(CNHValidator.strip(null), '');
  });

  test('CNH generator produces a deterministic valid registration', () {
    final random = RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8]);
    final generated = CNHValidator.generate(random: random);

    expect(generated, cnhWithIndependentCheckDigits('012345678'));
    expect(generated, '01234567807');
    expect(generated, matches(RegExp(r'^\d{11}$')));
    expect(CNHValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(9));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('CNH generator skips a blocklisted candidate', () {
    final random = RecordingRandom(<int>[
      ...List<int>.filled(9, 0),
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
    ]);
    final generated = CNHValidator.generate(random: random);
    final blocked = cnhWithIndependentCheckDigits('000000000');

    expect(blocked, '00000000000');
    expect(CNHValidator.blockList, contains(blocked));
    expect(generated, '01234567807');
    expect(CNHValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(18));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('CNH generator skips bases without valid check digits', () {
    // A base 225711825 deixa o primeiro resto em 10 e o segundo em 1, o que
    // não produz um segundo dígito de uma casa.
    expect(cnhWithIndependentCheckDigits('225711825'), isNull);

    final random = RecordingRandom(<int>[
      2,
      2,
      5,
      7,
      1,
      1,
      8,
      2,
      5,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
    ]);
    final generated = CNHValidator.generate(random: random);

    expect(generated, '01234567807');
    expect(CNHValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(18));
  });

  test('CNH generator agrees with an independent check-digit calculation', () {
    final random = Random(7);

    for (var attempt = 0; attempt < 50; attempt++) {
      final generated = CNHValidator.generate(random: random);

      expect(
        generated,
        cnhWithIndependentCheckDigits(generated.substring(0, 9)),
        reason: generated,
      );
      expect(CNHValidator.isValid(generated), isTrue, reason: generated);
    }
  });
}
