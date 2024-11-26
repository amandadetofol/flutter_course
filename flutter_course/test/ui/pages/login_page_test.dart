import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/helpers/helpers.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<String?> navigateToController;

  late LoginPresenter presenter;

  void initStreams() {
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    mainErrorController = StreamController<UIError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String?>.broadcast();
    presenter = LoginPresenterSpy();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

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
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  setUp(() {
    initStreams();
    mockStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    final loginPage = LoginPage(
      presenter: presenter,
    );

    final app = GetMaterialApp(
      home: loginPage,
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

  tearDown(() {
    closeStreams();
  });

  testWidgets(
    'Should present error when e-mail is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.invalidField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo inválido'),
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

      passwordErrorController.add(UIError.invalidField);

      await tester.pumpAndSettle();

      expect(
        find.text('Campo inválido'),
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
    'Should show error message ',
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.unexpected);
      await tester.pumpAndSettle();

      expect(find.text('Algo errado aconteceu'), findsOneWidget);
    },
  );

  testWidgets(
    'Should close streams on dispose ',
    (WidgetTester tester) async {
      await loadPage(tester);

      addTearDown(
        () => {
          verify(
            () => presenter.dispose(),
          ).called(1)
        },
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
    'Should call go to Signup on link click',
    (WidgetTester tester) async {
      await loadPage(tester);

      final button = find.text('Criar conta'.toUpperCase());
      await tester.tap(button);
      await tester.pumpAndSettle();

      verifyNever(
        () => presenter.goToSignUp(),
      );
    },
  );
}
