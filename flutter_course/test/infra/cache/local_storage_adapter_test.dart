import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/usecases/usecases.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorageSpy flutterSecureStorageSpy;
  late String key;
  late String value;
  late LocalStorageAdapter sut;

  mock() {
    when(() => flutterSecureStorageSpy.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async => Future.value());
  }

  mockError() {
    when(() => flutterSecureStorageSpy.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenThrow(Exception());
  }

  setUp(() {
    flutterSecureStorageSpy = FlutterSecureStorageSpy();
    key = faker.lorem.word();
    value = faker.guid.guid();

    sut = LocalStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);

    mock();
  });

  group('savesecure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(
        key,
        value,
      );

      verify(
        () => flutterSecureStorageSpy.write(
          key: key,
          value: value,
        ),
      ).called(1);
    });

    test('Should throw if save secure throws', () async {
      mockError();
      final response = sut.saveSecure(
        key,
        value,
      );

      expect(
        response,
        throwsA(const TypeMatcher<Exception>()),
      );
    });
  });

  group('fetchsecure', () {
    mockFetch() {
      when(() => flutterSecureStorageSpy.read(
            key: any(named: 'key'),
          )).thenAnswer((_) async => key);
    }

    mockFetchSecureError() {
      when(() => flutterSecureStorageSpy.read(
            key: any(named: 'key'),
          )).thenThrow(DomainError.unexpected);
    }

    test('Should call fetch secure with correct values', () async {
      mockFetch();

      await sut.fetchSecure(key);

      verify(
        () => flutterSecureStorageSpy.read(
          key: key,
        ),
      ).called(1);
    });

    test('Should return correct value', () async {
      mockFetch();

      final response = await sut.fetchSecure(key);

      expect(response, key);
    });

    test('Shoult throw Unexpected Error if Secure Storage throws', () async {
      mockFetchSecureError();

      final response = sut.fetchSecure(key);

      expect(response, throwsA(DomainError.unexpected));
    });
  });
}
