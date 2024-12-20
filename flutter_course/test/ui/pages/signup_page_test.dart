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
  late StreamController<String?> navigateToController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  late SignUpPresenter presenter;

  void initStreams() {
    navigateToController = StreamController<String?>.broadcast();
    mainErrorController = StreamController<UIError?>.broadcast();
    emailErrorController = StreamController<UIError?>.broadcast();
    passwordErrorController = StreamController<UIError?>.broadcast();
    nameErrorController = StreamController<UIError?>.broadcast();
    passwordConfirmationErrorController =
        StreamController<UIError?>.broadcast();
    isFormValidController = StreamController<bool>.broadcast();
    isLoadingController = StreamController<bool>.broadcast();
    presenter = SignUpPresenterSpy();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);

    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);

    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    nameErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
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
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => const Scaffold(
            body: Text('Enquetes'),
          ),
        ),
      ],
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

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isA<Function>());

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
    await tester.pumpAndSettle();
    verify(() => presenter.validateName(name)).called(1);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(() => presenter.validateEmail(email)).called(1);
    await tester.pump();

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password)).called(1);
    await tester.pump();

    await tester.enterText(
        find.bySemanticsLabel('Confirme sua senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password)).called(1);
    await tester.pump();
  });

  testWidgets(
    'Should present e-mail error',
    (WidgetTester tester) async {
      //campo invalido
      await loadPage(tester);

      emailErrorController.add(UIError.invalidField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo inválido'),
        findsOneWidget,
      );

      //campo obrigatorio
      await loadPage(tester);

      emailErrorController.add(UIError.requiredField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo obrigatório'),
        findsOneWidget,
      );

      //sem erro
      await loadPage(tester);

      emailErrorController.add(null);

      await tester.pumpAndSettle();

      expect(
        find.descendant(
            of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present name error',
    (WidgetTester tester) async {
      //campo obrigatorio
      await loadPage(tester);

      emailErrorController.add(UIError.requiredField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo obrigatório'),
        findsOneWidget,
      );

      //sem erro
      await loadPage(tester);

      emailErrorController.add(null);

      await tester.pumpAndSettle();

      expect(
        find.descendant(
            of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present password error',
    (WidgetTester tester) async {
      //sem erro
      await loadPage(tester);

      passwordErrorController.add(null);

      await tester.pumpAndSettle();

      expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget,
      );

      //campo obrigatorio
      await loadPage(tester);

      passwordErrorController.add(UIError.requiredField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo obrigatório'),
        findsNWidgets(3),
      );
    },
  );

  testWidgets(
    'Should present passwordConfirmation',
    (WidgetTester tester) async {
      //sem erro
      await loadPage(tester);

      passwordConfirmationErrorController.add(null);

      await tester.pumpAndSettle();

      expect(
        find.descendant(
            of: find.bySemanticsLabel('Confirme sua senha'),
            matching: find.byType(Text)),
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

  testWidgets(
    'Should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);

      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should hide loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump(const Duration(milliseconds: 100));

      isLoadingController.add(false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Should present error message if signup returns email in use error',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.emailInUse);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present error message if signup returns error',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.unexpected);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should navigate to page ',
    (WidgetTester tester) async {
      await loadPage(tester);

      final routeExpectation =
          expectLater(presenter.navigateToStream, emits('/surveys'));

      navigateToController.add('/surveys');

      await tester.pumpAndSettle();

      await Future.wait([
        routeExpectation,
      ]);
    },
  );

  testWidgets(
    'Should call goToLogin on link click ',
    (WidgetTester tester) async {
      await loadPage(tester);

      final button = find.text('Login');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      verifyNever(() {
        presenter.goToLogin();
      });
    },
  );
}
