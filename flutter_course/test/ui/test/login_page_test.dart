import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<String?> mainErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  late LoginPresenter presenter;

  void initStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    mainErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
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
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  setUp(() {
    initStreams();
    mockStreams();
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
    closeStreams();
  });

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

      mainErrorController.add('main error');
      await tester.pumpAndSettle();

      expect(find.text('main error'), findsOneWidget);
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
}
