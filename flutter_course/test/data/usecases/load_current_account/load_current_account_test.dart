import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/cache/cache.dart';
import 'package:flutter_course/lib/data/usecases/usecases.dart';
import 'package:flutter_course/lib/domain/entities/account_entity.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorageSpy;
  late String token;
  late LocalLoadCurrentAccount sut;

  mockFetch() {
    when(
      () => fetchSecureCacheStorageSpy.fetchSecure(
        any(),
      ),
    ).thenAnswer((_) async => token);
  }

  mockFetchError() {
    when(
      () => fetchSecureCacheStorageSpy.fetchSecure(
        any(),
      ),
    ).thenThrow(DomainError.unexpected);
  }

  setUp(() {
    token = faker.guid.guid();
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
    );

    mockFetch();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(
      () => fetchSecureCacheStorageSpy.fetchSecure(
        'token',
      ),
    ).called(1);
  });

  test('Should return correct value from fetchSecureCacheStorageSpy', () async {
    final response = await sut.load();

    expect(
      response,
      AccountEntity(token: token),
    );
  });

  test('Should throw a UnexpectedError if FetchSecure throws', () async {
    mockFetchError();

    final future = sut.load();

    expect(
      future,
      throwsA(DomainError.unexpected),
    );
  });
}
