import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/http/http.dart';
import 'package:flutter_course/lib/data/usecases/usecases.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ClientHttpSpy extends Mock implements ClientHttp {}

void main() {
  late ClientHttpSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParameters authenticationParameters;

  PostExpectation mock() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  setUp(
    () {
      httpClient = ClientHttpSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAuthentication(
        httpClient: httpClient,
        url: url,
        method: 'post',
      );
      authenticationParameters = AuthenticationParameters(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
    },
  );

  test(
    'Should call HttpClient with correct values',
    () async {
      mock().thenAnswer((_) async => {
            'accessToken': faker.guid.guid(),
            'name': faker.person.name(),
          });

      await sut.auth(parameters: authenticationParameters);

      verifyNever(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'key': authenticationParameters.email,
            'password': authenticationParameters.secret,
          },
        ),
      );
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 400',
    () async {
      mock().thenThrow(HttpError.badRequest);

      final future = sut.auth(parameters: authenticationParameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      mock().thenThrow(HttpError.notFound);

      final future = sut.auth(parameters: authenticationParameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      mock().thenThrow(HttpError.serverError);

      final future = sut.auth(parameters: authenticationParameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw InvalidCredentials if HttpClient returns 401',
    () async {
      mock().thenThrow(HttpError.unauthorized);

      final future = sut.auth(parameters: authenticationParameters);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should return an AccountEntity if HttpClient returns 200',
    () async {
      final token = faker.guid.guid();

      mock().thenAnswer((_) async => {
            'accessToken': token,
            'name': faker.person.name(),
          });

      final account = await sut.auth(parameters: authenticationParameters);

      expect(
        account?.token,
        token,
      );
    },
  );

  test(
    'Should return an UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      mock().thenAnswer((_) async => {
            'invalid_key': 'invalid_value',
          });

      final future = sut.auth(parameters: authenticationParameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
