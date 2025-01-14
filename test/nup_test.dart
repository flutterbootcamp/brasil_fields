import 'package:brasil_fields/src/validators/nup_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test NUP validator', () {
    expect(NUPValidator.isValid('0601064-21.2022.6.00.0000'), true);
    expect(NUPValidator.isValid('0601064-22.2022.6.00.0000'), false);
    expect(NUPValidator.isValid('00601064-22.2022.6.00.0000'), false);
    expect(NUPValidator.isValid('06010642120226000000'), true);
    expect(NUPValidator.isValid('06010642220226000000'), false);
    expect(NUPValidator.isValid('006010642120226000000'), false);
    expect(
        NUPValidator.isValid('03346teste1671002@mail',
            stripBeforeValidation: false),
        false);
    expect(
        NUPValidator.isValid('57abc803.6586-52', stripBeforeValidation: false),
        false);
  });

  test('Test NUP formatter', () {
    expect(NUPValidator.format('06010642120226000000'), '0601064-21.2022.6.00.0000');
  });

  test('Test NUP strip', () {
    expect(NUPValidator.strip('0601064-21.2022.6.00.0000'), '06010642120226000000');
  });
}
