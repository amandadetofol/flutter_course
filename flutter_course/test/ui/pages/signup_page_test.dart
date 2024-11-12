import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/helpers/helpers.dart';
import 'package:flutter_course/lib/ui/pages/signup/signup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;

  late SignUpPresenter presenter;

  void initStreams() {
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    nameErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();

    presenter = SignUpPresenterSpy();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(() => presenter.nameErrorController)
        .thenAnswer((_) => nameErrorController.stream);

    when(() => presenter.passwordConfirmationErrorController)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);

    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    nameErrorController.close();
  }

  setUp(() {
    initStreams();
    mockStreams();
  });

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = SignUpPage(presenter: presenter);

    final app = GetMaterialApp(
      home: signUpPage,
    );

    await tester.pumpWidget(app);
  }

  testWidgets(
    'Should load page with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      await tester.pump();

      expect(find.bySemanticsLabel('E-mail'), findsOneWidget);
      expect(find.bySemanticsLabel('Nome'), findsOneWidget);
      expect(find.bySemanticsLabel('Senha'), findsOneWidget);
      expect(find.bySemanticsLabel('Confirme sua senha'), findsOneWidget);

      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, null);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(
        find.descendant(
          of: find.bySemanticsLabel('E-mail'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.bySemanticsLabel('Nome'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.bySemanticsLabel('Confirme sua senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(
        find.bySemanticsLabel('Confirme sua senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });
}
