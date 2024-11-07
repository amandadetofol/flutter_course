import 'package:faker/faker.dart';
import 'package:flutter_course/lib/domain/entities/entities.dart';
import 'package:flutter_course/lib/domain/usecases/load_current_account.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoadCurrentAccoutSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccoutSpy loadCurrentAccount;
  late GetxSplashScreenPresenter sut;
  late String token;

  void mockPresenter() {
    when(() => loadCurrentAccount.load()).thenAnswer(
      (_) async => AccountEntity(token: token),
    );
  }

  void mockPresenterNull() {
    when(() => loadCurrentAccount.load()).thenAnswer(
      (_) async => null,
    );
  }

  setUp(() {
    token = faker.guid.guid();
    loadCurrentAccount = LoadCurrentAccoutSpy();
    sut = GetxSplashScreenPresenter(loadCurrentAccount: loadCurrentAccount);
    mockPresenter();
  });

  test('Should call load current account', () async {
    await sut.checkAccount();

    verify(
      () => loadCurrentAccount.load(),
    ).called(1);
  });

  test('Should go to surveys page on success', () async {
    await sut.checkAccount();

    sut.navigateToStream.listen((event) {
      expectAsync1(
        (page) => expect(page, 'surveys'),
      );
    });
  });

  test('Should go to login page on null result', () async {
    mockPresenterNull();

    await sut.checkAccount();

    sut.navigateToStream.listen((event) {
      expectAsync1(
        (page) => expect(page, 'surveys'),
      );
    });
  });
}
