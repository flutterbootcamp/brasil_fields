import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/deterministic_random.dart';

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
  });

  test(
    'PIS/PASEP validator rejects malformed raw values of the exact length',
    () {
      const malformed = <String>[
        '1201234567A',
        'A2012345672',
        '120123456-2',
        '120.2345672',
      ];

      for (final pis in malformed) {
        expect(
          PisPasepValidator.isValid(pis, stripBeforeValidation: false),
          isFalse,
          reason: pis,
        );
      }

      expect(
        PisPasepValidator.isValid(
          '120.12345.67-2',
          stripBeforeValidation: false,
        ),
        isFalse,
      );
      expect(
        PisPasepValidator.isValid('12012345672', stripBeforeValidation: false),
        isTrue,
      );
      expect(PisPasepValidator.isValid('120.12345.67-2'), isTrue);
      expect(PisPasepValidator.isValid('120.12345.67-3'), isFalse);
    },
  );

  test('Test PIS/PASEP formatter', () {
    expect(PisPasepValidator.format('12012345672'), '120.12345.67-2');
    expect(PisPasepValidator.format('120.12345.67-2'), '120.12345.67-2');
  });

  test('Test PIS/PASEP strip', () {
    expect(PisPasepValidator.strip('120.12345.67-2'), '12012345672');
    expect(PisPasepValidator.strip(null), '');
  });

  test(
    'PIS/PASEP generator covers shape, formatting, domain, and checksum',
    () {
      final rawRandom = RecordingRandom(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final raw = PisPasepValidator.generate(random: rawRandom);
      final formattedRandom = RecordingRandom(<int>[
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
      ]);
      final formatted = PisPasepValidator.generate(
        useFormat: true,
        random: formattedRandom,
      );

      expect(raw, '01234567897');
      expect(raw, matches(RegExp(r'^\d{11}$')));
      expect(formatted, '012.34567.89-7');
      expect(formatted, matches(RegExp(r'^\d{3}\.\d{5}\.\d{2}-\d$')));
      expect(PisPasepValidator.isValid(raw), isTrue);
      expect(PisPasepValidator.isValid(formatted), isTrue);
      expect(PisPasepValidator.strip(formatted), raw);
      expect(PisPasepValidator.format(raw), formatted);
      expect(rawRandom.requestedMaxValues, hasLength(10));
      expect(rawRandom.requestedMaxValues, everyElement(10));
      expect(formattedRandom.requestedMaxValues, hasLength(10));
      expect(formattedRandom.requestedMaxValues, everyElement(10));
      expect(raw.substring(0, 10).split('').toSet(), hasLength(10));
    },
  );

  test('PIS/PASEP generator skips a blocklisted candidate', () {
    final random = RecordingRandom(<int>[
      ...List<int>.filled(10, 0),
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
    ]);
    final generated = PisPasepValidator.generate(random: random);

    expect(generated, '90123456784');
    expect(PisPasepValidator.isValid(generated), isTrue);
    expect(random.requestedMaxValues, hasLength(20));
    expect(random.requestedMaxValues, everyElement(10));
  });

  test('PIS/PASEP generator stops after 100 blocklisted candidates', () {
    final random = RecordingRandom.constant(0);

    expect(
      () => PisPasepValidator.generate(random: random),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('100 tentativas'),
        ),
      ),
    );
    expect(random.requestedMaxValues, hasLength(100 * 10));
    expect(random.requestedMaxValues, everyElement(10));
  });
}
