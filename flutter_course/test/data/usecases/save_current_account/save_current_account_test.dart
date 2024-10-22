import 'package:faker/faker.dart';
import 'package:flutter_course/lib/domain/entities/account_entity.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_course/lib/domain/usecases/save_current_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  test('Should call SaveSecureCacheStorage with correct values', () async {
    final token = faker.guid.guid();
    final account = AccountEntity(token: token);
    final saveCacheStorage = SaveSecureCacheStorageSpy();

    final sut = LocalSaveCurrentAccount(
      saveCacheStorage: saveCacheStorage,
    );
    await sut.save(account);

    verify(
      () => saveCacheStorage.saveSecure(
        key: 'token',
        value: token,
      ),
    ).called(1);
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage fails',
      () async {
    final token = faker.guid.guid();
    final account = AccountEntity(token: token);
    final saveCacheStorage = SaveSecureCacheStorageSpy();

    when(() => saveCacheStorage.saveSecure(key: 'token', value: token))
        .thenThrow(Exception());

    final sut = LocalSaveCurrentAccount(
      saveCacheStorage: saveCacheStorage,
    );

    final future = sut.save(account);

    expect(
      future,
      throwsA(DomainError.unexpected),
    );
  });
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveCacheStorage;

  LocalSaveCurrentAccount({required this.saveCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      saveCacheStorage.saveSecure(
        key: 'token',
        value: account.token,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  void saveSecure({String key, String value});
}
