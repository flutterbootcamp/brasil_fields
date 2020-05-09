import 'package:brasil_fields/brasil_fields.dart';
import 'package:brasil_fields/formatter/cartao_credito_input_formatter.dart';
import 'package:brasil_fields/formatter/cnpj_input_formatter.dart';
import 'package:brasil_fields/formatter/hora_input_formatter.dart';
import 'package:brasil_fields/formatter/validade_cartao_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
              WhitelistingTextInputFormatter.digitsOnly,
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
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CpfInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
  });

  testWidgets('CnpjInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CnpjInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900099');
    expect(textController.text, '12.345.678/9000-99');
  });

  testWidgets('TelefoneInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();

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
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CepInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '12.345-678');
  });

  testWidgets('RealInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(RealInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, '1.234');

    await tester.pumpWidget(
        boilerplate(RealInputFormatter(centavos: true), textController));

    await tester.enterText(find.byType(TextField), '5678');
    expect(textController.text, '56,78');
  });

  testWidgets('DataInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(DataInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '01011900');
    expect(textController.text, '01/01/1900');
  });

  testWidgets('HoraInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(HoraInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '2130');
    expect(textController.text, '21:30');
  });

  testWidgets('CartaoCredito', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester
        .pumpWidget(boilerplate(CartaoCreditoInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '4040121298987373');
    expect(textController.text, '4040 1212 9898 7373');
  });
  testWidgets('ValidadeCartao', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(
        boilerplate(ValidadeCartaoInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1223');
    expect(textController.text, '12/23');
  });
}
