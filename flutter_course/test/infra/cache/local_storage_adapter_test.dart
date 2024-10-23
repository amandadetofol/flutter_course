import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/usecases/usecases.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorageSpy flutterSecureStorageSpy;
  late String key;
  late String value;
  late LocalStorageAdapter sut;

  setUp(() {
    flutterSecureStorageSpy = FlutterSecureStorageSpy();
    key = faker.lorem.word();
    value = faker.guid.guid();

    sut = LocalStorageAdapter(flutterSecureStorage: flutterSecureStorageSpy);
  });

  test('Should call save secure with correct values', () async {
    when(() => flutterSecureStorageSpy.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async => Future.value());

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
    when(() => flutterSecureStorageSpy.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenThrow(Exception());

    final response = sut.saveSecure(
      key,
      value,
    );

    expect(
      response,
      throwsA(const TypeMatcher<Exception>()),
    );
  });
}
