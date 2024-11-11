import 'package:faker/faker.dart';
import 'package:flutter_course/lib/data/http/http.dart';
import 'package:flutter_course/lib/data/usecases/usecases.dart';
import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ClientHttpSpy extends Mock implements ClientHttp {}

void main() {
  late ClientHttpSpy httpClient;
  late String url;
  late String password;
  late RemoteAddAccount sut;
  late AddAccountParams addAccountParameters;

  PostExpectation mock() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  void mockData(Map data) {
    mock().thenAnswer((realInvocation) async => data);
  }

  void mockError(HttpError error) {
    mock().thenThrow(error);
  }

  setUp(
    () {
      password = faker.internet.password();
      httpClient = ClientHttpSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAddAccount(
        httpClient: httpClient,
        url: url,
        method: 'post',
      );

      addAccountParameters = AddAccountParams(
        email: faker.internet.email(),
        name: faker.internet.userName(),
        password: password,
        passwordConfirmation: password,
      );

      mockData(
        {
          'name': addAccountParameters.name,
          'email': addAccountParameters.email,
          'password': addAccountParameters.password,
          'passwordConfirmation': addAccountParameters.password,
        },
      );
    },
  );

  test(
    'Should call HttpClient with correct values',
    () async {
      await sut.add(parameters: addAccountParameters);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': addAccountParameters.email,
            'name': addAccountParameters.name,
            'password': addAccountParameters.password,
            'passwordConfirmation': addAccountParameters.passwordConfirmation,
          },
        ),
      );
    },
  );
}
