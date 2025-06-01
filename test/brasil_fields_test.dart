import 'package:brasil_fields/brasil_fields.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget boilerplateAlphaNumerico(
    TextInputFormatter inputFormatter, TextEditingController textController) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(size: Size(320, 480)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: TextField(
            controller: textController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
              inputFormatter,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget boilerplate(
    TextInputFormatter inputFormatter, TextEditingController textController) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(size: Size(320, 480)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: TextField(
            controller: textController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              inputFormatter,
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('CpfInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CpfInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
  });

  testWidgets('CnpjInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CnpjInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900099');
    expect(textController.text, '12.345.678/9000-99');
  });

  testWidgets('CnpjAlfanumericoInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplateAlphaNumerico(
        CnpjAlfanumericoInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), 'A2B4C6D8E0F099');
    expect(textController.text, 'A2.B4C.6D8/E0F0-99');
  });

  testWidgets('TelefoneInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester
        .pumpWidget(boilerplate(TelefoneInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '9912345678');
    expect(textController.text, '(99) 1234-5678');

    await tester
        .pumpWidget(boilerplate(TelefoneInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '00987654321');

    expect(textController.text, '(00) 98765-4321');
  });

  testWidgets('CepInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CepInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '123456789');
    expect(textController.text, '');

    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '12.345-678');

    await tester.pumpWidget(
        boilerplate(CepInputFormatter(ponto: false), textController));

    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '12345-678');
  });

  testWidgets('RealInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(RealInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1256780');
    expect(textController.text, '1.256.780');
    await tester.enterText(find.byType(TextField), '125678');
    expect(textController.text, '125.678');
    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, '1.234');

    await tester.enterText(find.byType(TextField), '5678');
    expect(textController.text, '5.678');

    await tester.enterText(find.byType(TextField), '678');
    expect(textController.text, '678');

    await tester.enterText(find.byType(TextField), '78');
    expect(textController.text, '78');

    await tester.enterText(find.byType(TextField), '8');
    expect(textController.text, '8');
  });

  testWidgets('RealInputFormatter + moeda', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(
        boilerplate(RealInputFormatter(moeda: true), textController));

    await tester.enterText(find.byType(TextField), '1256780');
    expect(textController.text, 'R\$ 1.256.780');

    await tester.enterText(find.byType(TextField), '125678');
    expect(textController.text, 'R\$ 125.678');

    await tester.enterText(find.byType(TextField), '5678');
    expect(textController.text, 'R\$ 5.678');

    await tester.enterText(find.byType(TextField), '678');
    expect(textController.text, 'R\$ 678');

    await tester.enterText(find.byType(TextField), '78');
    expect(textController.text, 'R\$ 78');

    await tester.enterText(find.byType(TextField), '8');
    expect(textController.text, 'R\$ 8');
  });

  testWidgets('CentavosInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester
        .pumpWidget(boilerplate(CentavosInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12567');
    expect(textController.text, '125,67');

    await tester.enterText(find.byType(TextField), '567');
    expect(textController.text, '5,67');

    await tester.enterText(find.byType(TextField), '67');
    expect(textController.text, '0,67');

    await tester.enterText(find.byType(TextField), '8');
    expect(textController.text, '0,08');
  });

  testWidgets('CentavosInputFormatter 3 decimais', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(
        boilerplate(CentavosInputFormatter(casasDecimais: 3), textController));

    await tester.enterText(find.byType(TextField), '125678');
    expect(textController.text, '125,678');

    await tester.enterText(find.byType(TextField), '5678');
    expect(textController.text, '5,678');

    await tester.enterText(find.byType(TextField), '678');
    expect(textController.text, '0,678');

    await tester.enterText(find.byType(TextField), '78');
    expect(textController.text, '0,078');

    await tester.enterText(find.byType(TextField), '8');
    expect(textController.text, '0,008');
  });

  testWidgets('DataInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(DataInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '01011900');
    expect(textController.text, '01/01/1900');
  });

  testWidgets('CertNascimentoFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(
        boilerplate(CertNascimentoInputFormatter(), textController));

    await tester.enterText(
        find.byType(TextField), '11111122334444566666777888888899');
    expect(textController.text, '111111 22 33 4444 5 66666 777 8888888 99');
  });

  testWidgets('HoraInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(HoraInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '2130');
    expect(textController.text, '21:30');
  });

  testWidgets('CartaoBancarioInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(
        boilerplate(CartaoBancarioInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '4040121298987373');
    expect(textController.text, '4040 1212 9898 7373');
  });
  testWidgets('ValidadeCartaoInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(
        boilerplate(ValidadeCartaoInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1223');
    expect(textController.text, '12/23');
  });

  testWidgets('TemperaturaInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester
        .pumpWidget(boilerplate(TemperaturaInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '176');
    expect(textController.text, '17,6');
  });

  testWidgets('PesoInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '889');
    expect(textController.text, '88,9');

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '1043');
    expect(textController.text, '104,3');
  });

  testWidgets('PlacaVeiculoInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    // testa toUpperCase
    await tester.pumpWidget(
        boilerplateAlphaNumerico(PlacaVeiculoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), 'abc');
    expect(textController.text, 'ABC');

    await tester.pumpWidget(
        boilerplateAlphaNumerico(PlacaVeiculoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), 'abc-1234');
    expect(textController.text, 'ABC-1234');
  });

  testWidgets('KmInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(KmInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '120');
    expect(textController.text, '120');

    await tester.pumpWidget(boilerplate(KmInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, '1.234');

    await tester.pumpWidget(boilerplate(KmInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '12345');
    expect(textController.text, '12.345');

    await tester.pumpWidget(boilerplate(KmInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '123456');
    expect(textController.text, '123.456');
  });

  testWidgets('Compound of CPF and CPNJ', (WidgetTester tester) async {
    final textController = TextEditingController();
    final formatter = CompoundFormatter([
      CpfInputFormatter(),
      CnpjInputFormatter(),
    ]);

    // Esperamos os resultados no seguinte formato:
    // '123.456.789-00'      // CPF
    // '12.345.678/9000-99'  // CPNJ

    await tester.pumpWidget(boilerplate(formatter, textController));
    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
    await tester.enterText(find.byType(TextField), '123456789000');
    expect(textController.text, '12.345.678/9000');
    await tester.enterText(find.byType(TextField), '1234567890009');
    expect(textController.text, '12.345.678/9000-9');
    await tester.enterText(find.byType(TextField), '12345678900099');
    expect(textController.text, '12.345.678/9000-99');
  });

  testWidgets('CPFToCPNJFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    final formatter = CpfOuCnpjFormatter();

    // Esperamos os resultados no seguinte formato:
    // '123.456.789-00'      // CPF
    // '12.345.678/9000-99'  // CPNJ

    await tester.pumpWidget(boilerplate(formatter, textController));
    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
    await tester.enterText(find.byType(TextField), '123456789000');
    expect(textController.text, '12.345.678/9000');
    await tester.enterText(find.byType(TextField), '1234567890009');
    expect(textController.text, '12.345.678/9000-9');
    await tester.enterText(find.byType(TextField), '12345678900099');
    expect(textController.text, '12.345.678/9000-99');
  });

  testWidgets('CpfOuCnpjAlfanumericoFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    final formatter = CpfOuCnpjAlfanumericoFormatter();

    // Esperamos os resultados no seguinte formato:
    // '123.456.789-00'      // CPF
    // '12.345.678/900A-99'  // CPNJ

    await tester
        .pumpWidget(boilerplateAlphaNumerico(formatter, textController));
    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
    await tester.enterText(find.byType(TextField), '12345678900A');
    expect(textController.text, '12.345.678/900A');
    await tester.enterText(find.byType(TextField), '12345678900A9');
    expect(textController.text, '12.345.678/900A-9');
    await tester.enterText(find.byType(TextField), '12345678900A99');
    expect(textController.text, '12.345.678/900A-99');
  });

  testWidgets('IOFInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(IOFInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '12345');
    expect(textController.text, '1,2345');

    await tester.pumpWidget(boilerplate(IOFInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '123456');
    expect(textController.text, '1,23456');

    await tester.pumpWidget(boilerplate(IOFInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '1234567');
    expect(textController.text, '1,234567');

    await tester.pumpWidget(boilerplate(IOFInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '1,234567');
  });

  testWidgets('NCMInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(NCMInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '03099000');
    expect(textController.text, '0309.90.00');
  });

  testWidgets('NUPInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(NUPInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '12345678901234567890');
    expect(textController.text, '1234567-89.0123.4.56.7890');
  });

  testWidgets('CESTInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(CESTInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '0101800');
    expect(textController.text, '01.018.00');
  });

  testWidgets('CNSInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(CNSInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '404012129898737');
    expect(textController.text, '404 0121 2989 8737');
  });
}
