import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool> isFormValidController;

  late LoginPresenter presenter;

  setUp(() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    presenter = LoginPresenterSpy();

    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    when(() => presenter.isValidFormStream)
        .thenAnswer((_) => isFormValidController.stream);
  });

  Future<void> loadPage(WidgetTester tester) async {
    final loginPage = LoginPage(
      presenter: presenter,
    );

    final app = MaterialApp(
      home: loginPage,
    );

    await tester.pumpWidget(app);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

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

  testWidgets(
    'Should present error when e-mail is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');

      await tester.pumpAndSettle();

      expect(
        find.text('any error'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present no error when e-mail is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);

      await tester.pumpAndSettle();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present error when password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');

      await tester.pumpAndSettle();

      expect(
        find.text('any error'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present error when password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');

      await tester.pumpAndSettle();

      expect(
        find.text('any error'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present no error when password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);

      await tester.pumpAndSettle();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present no error when password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');

      await tester.pumpAndSettle();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present no error when password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');

      await tester.pumpAndSettle();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should enable form button when form if valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(
        button.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'Should disable form button when form if valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);

      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(
        button.onPressed,
        null,
      );
    },
  );
}
