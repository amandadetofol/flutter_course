import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter = LoginPresenterSpy();

  Future<void> loadPage(WidgetTester tester) async {
    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenter,
      ),
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

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('E-mail'), email);
      verify(() => presenter.validateEmail(email)).called(1);

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(() => presenter.validatePassword(password)).called(1);
    },
  );
}
