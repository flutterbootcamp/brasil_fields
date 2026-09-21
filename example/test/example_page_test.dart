import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('all navigation sections contain real examples', (tester) async {
    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    expect(find.text('Digite. Formate. Confira na hora.'), findsOneWidget);
    expect(find.text('Em breve'), findsNothing);

    await tester.tap(find.text('Datas'));
    await tester.pumpAndSettle();
    expect(find.text('Datas brasileiras sem improviso.'), findsOneWidget);
    expect(find.byKey(const Key('date-demo-field')), findsOneWidget);
    expect(find.text('Ano  2026'), findsOneWidget);

    DefaultTabController.of(tester.element(find.byType(TabBar))).animateTo(2);
    await tester.pumpAndSettle();
    expect(find.text('Padrões brasileiros em um só lugar.'), findsOneWidget);
    expect(find.text('Em breve'), findsNothing);
  });

  testWidgets('formats CEP input', (tester) async {
    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('formatter-search')),
      'cep',
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('formatters-page')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    final field = find.byKey(const Key('formatter-cep'));
    expect(find.text('CepInputFormatter'), findsOneWidget);
    await tester.enterText(field, '12345678');
    await tester.pump();

    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    expect(editable.controller.text, '12.345-678');
  });

  testWidgets('search filters formatters and alphanumeric input is formatted',
      (tester) async {
    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('formatter-search')),
      'placa',
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('formatters-page')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('formatter-placa')), findsOneWidget);
    expect(find.text('PlacaVeiculoInputFormatter'), findsOneWidget);
    expect(find.byKey(const Key('formatter-cpf')), findsNothing);

    final field = find.byKey(const Key('formatter-placa'));
    await tester.enterText(field, 'bra2e19');
    await tester.pump();

    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    expect(editable.controller.text, 'BRA-2E19');
  });

  testWidgets('shows and formats the latest PIS/PASEP formatter',
      (tester) async {
    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('formatter-search')),
      'PIS',
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('formatters-page')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    final field = find.byKey(const Key('formatter-pis-pasep'));
    expect(field, findsOneWidget);
    expect(find.text('PisPasepInputFormatter'), findsOneWidget);

    await tester.enterText(field, '12012345672');
    await tester.pump();

    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    expect(editable.controller.text, '120.12345.67-2');
  });

  testWidgets('narrow layout renders without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    expect(find.text('Formatadores'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Datas'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('dates-page')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    DefaultTabController.of(tester.element(find.byType(TabBar))).animateTo(2);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const PageStorageKey('standards-page')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop layout follows the system dark theme', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(
      tester.platformDispatcher.clearPlatformBrightnessTestValue,
    );

    await tester.pumpWidget(const BrasilFieldsApp());
    await tester.pumpAndSettle();

    final scaffoldContext = tester.element(find.byType(Scaffold));
    expect(Theme.of(scaffoldContext).brightness, Brightness.dark);
    expect(find.text('Digite. Formate. Confira na hora.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
