import 'package:brasil_fields/brasil_fields.dart';

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
}
