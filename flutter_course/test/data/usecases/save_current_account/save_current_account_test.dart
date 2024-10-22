import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/cache/cache.dart';
import 'package:flutter_course/lib/data/usecases/save_secure_cache_storage/save_secure_cache_stoage_impl.dart';
import 'package:flutter_course/lib/domain/entities/account_entity.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  late String token;
  late AccountEntity account;
  late SaveSecureCacheStorageSpy saveCacheStorage;
  late LocalSaveCurrentAccount sut;

  setUpAll(() {
    token = faker.guid.guid();
    account = AccountEntity(token: token);
    saveCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(
      saveCacheStorage: saveCacheStorage,
    );
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
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
    when(() => saveCacheStorage.saveSecure(key: 'token', value: token))
        .thenThrow(Exception());

    final future = sut.save(account);

    expect(
      future,
      throwsA(DomainError.unexpected),
    );
  });
}
