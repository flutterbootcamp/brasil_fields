import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  evaluate(String oldValue, String newValue, [bool moeda = false]) {
    return RealInputFormatter(moeda: moeda)
        .formatEditUpdate(
          TextEditingValue(text: oldValue),
          TextEditingValue(text: newValue),
        )
        .text;
  }

  group('RealInputFormatter', () {
    test('padrao',
        () => expect(evaluate('', '111222333444'), '111.222.333.444'));
    test(
      'padrao [moeda: true]',
      () => expect(evaluate('', '111222333444', true), 'R\$ 111.222.333.444'),
    );
    test('limite 12 digitos', () => expect(evaluate('', '9111222333444'), ''));
    test(
      'limite 12 digitos [moeda: true]',
      () => expect(evaluate('', '9111222333444', true), ''),
    );

    test('backspace', () {
      expect(evaluate('', '12345678900'), '12.345.678.900');
      expect(evaluate('', '1234567890'), '1.234.567.890');
      expect(evaluate('', '123456789'), '123.456.789');
      expect(evaluate('', '12345678'), '12.345.678');
      expect(evaluate('', '1234567'), '1.234.567');
      expect(evaluate('', '123456'), '123.456');
      expect(evaluate('', '12345'), '12.345');
      expect(evaluate('', '1234'), '1.234');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '1'), '1');
      expect(evaluate('', ''), '');
    });

    test('backspace [moeda: true]', () {
      expect(evaluate('', '12345678900', true), 'R\$ 12.345.678.900');
      expect(evaluate('', '1234567890', true), 'R\$ 1.234.567.890');
      expect(evaluate('', '123456789', true), 'R\$ 123.456.789');
      expect(evaluate('', '12345678', true), 'R\$ 12.345.678');
      expect(evaluate('', '1234567', true), 'R\$ 1.234.567');
      expect(evaluate('', '123456', true), 'R\$ 123.456');
      expect(evaluate('', '12345', true), 'R\$ 12.345');
      expect(evaluate('', '1234', true), 'R\$ 1.234');
      expect(evaluate('', '123', true), 'R\$ 123');
      expect(evaluate('', '12', true), 'R\$ 12');
      expect(evaluate('', '1', true), 'R\$ 1');
      expect(evaluate('', '', true), '');
    });

    test('digitacao', () {
      expect(evaluate('', '1'), '1');
      expect(evaluate('', '12'), '12');
      expect(evaluate('', '123'), '123');
      expect(evaluate('', '1234'), '1.234');
      expect(evaluate('', '12345'), '12.345');
      expect(evaluate('', '123456'), '123.456');
      expect(evaluate('', '1234567'), '1.234.567');
      expect(evaluate('', '12345678'), '12.345.678');
      expect(evaluate('', '123456789'), '123.456.789');
      expect(evaluate('', '1234567890'), '1.234.567.890');
      expect(evaluate('', '12345678900'), '12.345.678.900');
    });

    test('digitacao [moeda: true]', () {
      expect(evaluate('', '1', true), 'R\$ 1');
      expect(evaluate('', '12', true), 'R\$ 12');
      expect(evaluate('', '123', true), 'R\$ 123');
      expect(evaluate('', '1234', true), 'R\$ 1.234');
      expect(evaluate('', '12345', true), 'R\$ 12.345');
      expect(evaluate('', '123456', true), 'R\$ 123.456');
      expect(evaluate('', '1234567', true), 'R\$ 1.234.567');
      expect(evaluate('', '12345678', true), 'R\$ 12.345.678');
      expect(evaluate('', '123456789', true), 'R\$ 123.456.789');
      expect(evaluate('', '1234567890', true), 'R\$ 1.234.567.890');
      expect(evaluate('', '12345678900', true), 'R\$ 12.345.678.900');
    });
  });
}
