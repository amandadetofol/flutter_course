import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage flutterSecureStorage;

  LocalStorageAdapter({required this.flutterSecureStorage});

  @override
  Future<void> saveSecure(
    String key,
    String value,
  ) async {
    await flutterSecureStorage.write(
      key: key,
      value: value,
    );
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  test('Should call save secure with correct values', () async {
    final flutterSecureStorageSpy = FlutterSecureStorageSpy();

    when(() => flutterSecureStorageSpy.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async => Future.value());

    final key = faker.lorem.word();
    final value = faker.guid.guid();

    final sut =
        LocalStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);

    await sut.saveSecure(
      key,
      value,
    );

    verify(() => flutterSecureStorageSpy.write(
          key: key,
          value: value,
        )).called(1);
  });
}
