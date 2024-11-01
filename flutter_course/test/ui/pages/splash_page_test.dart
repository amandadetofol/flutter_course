import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;

  void mockPresenter() {
    when(() => presenter.loadCurrentAccount()).thenAnswer((_) async {});
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
        ],
      ),
    );
  }

  setUpAll(() {
    presenter = SplashPresenterSpy();
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
      mockPresenter();
      await loadPage(tester);

      verify(
        () => presenter.loadCurrentAccount(),
      ).called(1);
    },
  );
}

abstract class SplashPresenter {
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
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
