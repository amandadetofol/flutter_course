import 'package:flutter_course/lib/data/http/http.dart';
import 'package:flutter_course/lib/infra/http.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;

  late ClientSpy client;
  late HttpAdapter sut;
  late Map body;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    body = {'any_key': 'any_value'};
  });

  setUpAll(() {
    url = faker.internet.httpUrl();

    registerFallbackValue(Uri.parse(url));
  });

  group(
    'POST',
    () {
      mock() => when(
            () => client.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          );

      void mockResponse(int statusCode, String body) {
        mock().thenAnswer(
          (_) async => Response(body, statusCode),
        );
      }

      setUp(() {
        mockResponse(200, '{"any_key":"any_value"}');
      });

      test(
        'Should call post with correct values',
        () async {
          await sut.request(url: url, method: 'post');

          verify(
            () => client.post(
              Uri.parse(
                url,
              ),
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
            ),
          );
        },
      );

      test(
        'Should call post with body',
        () async {
          await sut.request(
            url: url,
            method: 'post',
            body: body,
          );

          verify(
            () => client.post(
                Uri.parse(
                  url,
                ),
                headers: {
                  'content-type': 'application/json',
                  'accept': 'application/json',
                },
                body: '{"any_key":"any_value"}'),
          );
        },
      );

      test(
        'Should call post without body',
        () async {
          await sut.request(
            url: url,
            method: 'post',
          );

          verify(
            () => client.post(
              Uri.parse(
                url,
              ),
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
            ),
          );
        },
      );

      test(
        'Should return data when post return 200',
        () async {
          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, body);
        },
      );

      test(
        'Should return null when post return 200 with no data',
        () async {
          mockResponse(200, '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );

      test(
        'Should return null when post return 204',
        () async {
          mockResponse(204, '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );

      test(
        'Should return null when post return 204 with data',
        () async {
          mockResponse(204, '{"any_key": "any_value"}');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );

      test(
        'Should return badrequest error when post return 400 with empty body',
        () async {
          mockResponse(400, '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return badrequest error when post return 400 with empty body',
        () async {
          mockResponse(400, '{"any_key": "any_value"}');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return server error when post return 500',
        () async {
          mockResponse(500, '{"any_key": "any_value"}');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.serverError),
          );
        },
      );

      test(
        'Should return unauthorized error when post return 401',
        () async {
          mockResponse(401, '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.unauthorized),
          );
        },
      );

      test(
        'Should return forbidden error when post return 403',
        () async {
          mockResponse(403, '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.forbidden),
          );
        },
      );

      test(
        'Should return not found error when post return 404',
        () async {
          mockResponse(404, '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.notFound),
          );
        },
      );
    },
  );

  group(
    'shared ',
    () {
      mock() => when(
            () => client.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          );

      void mockError() {
        mock().thenAnswer(
          (_) async => Response('', 500),
        );
      }

      test(
        'Should throw server error if invalid method is provided',
        () async {
          final future = sut.request(url: url, method: 'invalid_method');

          expect(future, throwsA(HttpError.serverError));
        },
      );

      test(
        'Should throw server error if post throws',
        () async {
          mockError();

          final future = sut.request(url: url, method: 'invalid_method');

          expect(future, throwsA(HttpError.serverError));
        },
      );
    },
  );
}
