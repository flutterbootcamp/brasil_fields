// @dart = 2.9
import 'package:brasil_fields/brasil_fields.dart';

import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/cpf_ou_cpnj_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget boilerplate(TextInputFormatter inputFormatter, TextEditingController textController) {
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

  testWidgets('TelefoneInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(TelefoneInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '9912345678');
    expect(textController.text, '(99) 1234-5678');

    await tester.pumpWidget(boilerplate(TelefoneInputFormatter(), textController));
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

    await tester.pumpWidget(boilerplate(CepInputFormatter(ponto: false), textController));

    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '12345-678');
  });

  testWidgets('RealInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(RealInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, 'R\$ 1.234');

    await tester.pumpWidget(boilerplate(RealInputFormatter(centavos: true), textController));

    await tester.enterText(find.byType(TextField), '125678');
    expect(textController.text, 'R\$ 1.256,78');

    await tester.enterText(find.byType(TextField), '5678');
    expect(textController.text, 'R\$ 56,78');

    await tester.enterText(find.byType(TextField), '678');
    expect(textController.text, 'R\$ 6,78');

    await tester.enterText(find.byType(TextField), '78');
    expect(textController.text, 'R\$ 0,78');

    await tester.enterText(find.byType(TextField), '8');
    expect(textController.text, 'R\$ 0,08');
  });

  testWidgets('DataInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(DataInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '01011900');
    expect(textController.text, '01/01/1900');
  });

  testWidgets('HoraInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(HoraInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '2130');
    expect(textController.text, '21:30');
  });

  testWidgets('CartaoCredito', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CartaoBancarioInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '4040121298987373');
    expect(textController.text, '4040 1212 9898 7373');
  });
  testWidgets('ValidadeCartao', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(ValidadeCartaoInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1223');
    expect(textController.text, '12/23');
  });

  testWidgets('Altura', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplate(AlturaInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '176');
    expect(textController.text, '1,76');
  });

  testWidgets('Peso', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '889');
    expect(textController.text, '88,9');

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '1043');
    expect(textController.text, '104,3');
  });

  testWidgets('KM', (WidgetTester tester) async {
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
}
