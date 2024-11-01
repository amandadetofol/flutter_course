import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;
  late StreamController<String> navigateToController;

  void mockPresenter() {
    when(() => presenter.loadCurrentAccount()).thenAnswer((_) async {});
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

  setUpAll(() {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();

    mockPresenter();
    mockPresenterNavigateTo();
  });

  tearDown(() {
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
        () => presenter.loadCurrentAccount(),
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

abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadCurrentAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4Dev'),
      ),
      body: Builder(builder: (context) {
        widget.presenter.navigateToStream.listen((pageRoute) {
          if (pageRoute.isNotEmpty == true) {
            Get.offAllNamed(pageRoute);
          }
        });

        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
