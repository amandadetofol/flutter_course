import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    const loginPage = MaterialApp(
      home: LoginPage(),
    );

    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'),
        matching: find.byType(Text),
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed, null);

      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'When a TextFormField has only text child, means it has no errors, since one of the childs is always the hint text',
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            'When a TextFormField has only text child, means it has no errors, since one of the childs is always the hint text',
      );
    },
  );

  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);
    },
  );
}
