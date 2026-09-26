import 'package:brasil_fields/brasil_fields.dart';
import 'package:brasil_fields/src/formatters/compound_formatters/compound_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'src/formatters/formatter_test_harness.dart';

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
  testWidgets('CnpjAlfanumericoInputFormatter em digitacao sequencial',
      (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(boilerplateAlphaNumerico(
      CnpjAlfanumericoInputFormatter(),
      textController,
    ));
    await tester.tap(find.byType(TextField));

    for (final character in 'A2B4C6D8E0F099'.split('')) {
      final newText = '${textController.text}$character';
      tester.testTextInput.updateEditingValue(textEditingValue(newText));
      await tester.pump();
      expectCollapsedSelectionAtEnd(textController.value);
    }

    expect(textController.text, 'A2.B4C.6D8/E0F0-99');
  });

  for (final configuration in [
    (moeda: false, casasDecimais: 2),
    (moeda: true, casasDecimais: 2),
    (moeda: false, casasDecimais: 3),
    (moeda: true, casasDecimais: 3),
  ]) {
    testWidgets(
      'CentavosInputFormatter limpa selecao total '
      'moeda=${configuration.moeda}, '
      'casasDecimais=${configuration.casasDecimais}',
      (WidgetTester tester) async {
        final textController = TextEditingController();
        await tester.pumpWidget(boilerplate(
          CentavosInputFormatter(
            moeda: configuration.moeda,
            casasDecimais: configuration.casasDecimais,
          ),
          textController,
        ));
        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), '12345');

        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
        tester.testTextInput.updateEditingValue(textEditingValue(''));
        await tester.pump();

        expect(textController.value, textEditingValue(''));
      },
    );
  }

  testWidgets('CentavosInputFormatter edicoes no meio e no separador',
      (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester
        .pumpWidget(boilerplate(CentavosInputFormatter(), textController));
    await tester.tap(find.byType(TextField));

    await tester.enterText(find.byType(TextField), '12345');
    expect(textController.text, '123,45');
    textController.selection = const TextSelection.collapsed(offset: 1);
    tester.testTextInput.updateEditingValue(textEditingValue(
      '1923,45',
      selection: const TextSelection.collapsed(offset: 2),
    ));
    await tester.pump();
    expect(textController.text, '1.923,45');
    expectCollapsedSelectionAtEnd(textController.value);

    await tester.enterText(find.byType(TextField), '12345');
    textController.selection =
        const TextSelection(baseOffset: 1, extentOffset: 3);
    tester.testTextInput.updateEditingValue(textEditingValue(
      '19,45',
      selection: const TextSelection.collapsed(offset: 2),
    ));
    await tester.pump();
    expect(textController.text, '19,45');
    expectCollapsedSelectionAtEnd(textController.value);

    await tester.enterText(find.byType(TextField), '12345');
    textController.selection = const TextSelection.collapsed(offset: 4);
    tester.testTextInput.updateEditingValue(textEditingValue(
      '12345',
      selection: const TextSelection.collapsed(offset: 3),
    ));
    await tester.pump();
    expect(textController.text, '123,45');
    expectCollapsedSelectionAtEnd(textController.value);
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

  testWidgets('PesoInputFormatter', (WidgetTester tester) async {
    final textController = TextEditingController();

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '889');
    expect(textController.text, '88,9');

    await tester.pumpWidget(boilerplate(PesoInputFormatter(), textController));
    await tester.enterText(find.byType(TextField), '1043');
    expect(textController.text, '104,3');
  });

  testWidgets('Compound of CPF and CPNJ', (WidgetTester tester) async {
    final textController = TextEditingController();
    final formatter = CompoundFormatter([
      CpfInputFormatter(),
      CnpjInputFormatter(),
    ]);

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
}
