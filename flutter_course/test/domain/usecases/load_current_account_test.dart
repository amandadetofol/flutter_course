import 'package:faker/faker.dart';
import 'package:flutter_course/lib/domain/entities/account_entity.dart';
import 'package:flutter_course/lib/domain/usecases/load_current_account.dart';
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
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    return AccountEntity(token: token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}
