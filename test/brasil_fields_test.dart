import 'package:brasil_fields/brasil_fields.dart';
import 'package:brasil_fields/formatter/cnpj_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget boilerplate(
    TextInputFormatter inputFormatter, TextEditingController textController) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(size: Size(800.0, 600.0)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: TextField(
            controller: textController,
            decoration: null,
            inputFormatters: <TextInputFormatter>[
              inputFormatter,
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('testa CpfInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CpfInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900');
    expect(textController.text, '123.456.789-00');
  });

  testWidgets('testa CnpjInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CnpjInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678900099');
    expect(textController.text, '12.345.678/9000-99');
  });

  testWidgets('testa TelefoneInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester
        .pumpWidget(boilerplate(TelefoneInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '9912345678');
    expect(textController.text, '(99) 1234-5678');

    await tester.pumpWidget(
        boilerplate(TelefoneInputFormatter(digito_9: true), textController));

    await tester.enterText(find.byType(TextField), '00123456789');
    expect(textController.text, '(00) 12345-6789');
  });

  testWidgets('testa CepInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(CepInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '12345678');
    expect(textController.text, '12.345-678');
  });

  testWidgets('testa RealInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(RealInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, '1.234');

    await tester.pumpWidget(
        boilerplate(RealInputFormatter(centavos: true), textController));

    await tester.enterText(find.byType(TextField), '1234');
    expect(textController.text, '12,34');
  });

  testWidgets('testa DataInputFormatter', (WidgetTester tester) async {
    final TextEditingController textController = TextEditingController();
    await tester.pumpWidget(boilerplate(DataInputFormatter(), textController));

    await tester.enterText(find.byType(TextField), '01011900');
    expect(textController.text, '01/01/1900');
  });
}
