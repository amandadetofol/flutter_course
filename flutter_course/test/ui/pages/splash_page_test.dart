import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/splash/splash.dart';
import 'package:flutter_course/lib/ui/pages/splash/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;
  late StreamController<String> navigateToController;

  void mockPresenter() {
    when(() => presenter.checkAccount()).thenAnswer((_) async {});
  }

  void mockPresenterNavigateTo() {
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => SplashPage(presenter: presenter),
          ),
          GetPage(
            name: '/any_route',
            page: () => Scaffold(
              appBar: AppBar(
                title: const Text('fake page'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setUp(() {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>.broadcast();
    mockPresenter();
    mockPresenterNavigateTo();
  });

  tearDown(() {
    navigateToController.close();
    clearInteractions(presenter);
    navigateToController.close();
  });

  testWidgets(
    'Should present spinner on page load',
    (tester) async {
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should call load current account on page load',
    (tester) async {
      await loadPage(tester);

      verify(
        () => presenter.checkAccount(),
      ).called(1);
    },
  );

  testWidgets(
    'Should change page',
    (tester) async {
      await loadPage(tester);

      navigateToController.add('/any_route');

      await tester.pumpAndSettle();

      expect(Get.currentRoute, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    'Should not change page if page is empty',
    (tester) async {
      await loadPage(tester);

      navigateToController.add('');
      await tester.pump();
      expect(Get.currentRoute, '/');
      expect(find.text('fake page'), findsNothing);
    },
  );
}
