import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    await client.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;

  late ClientSpy client;
  late HttpAdapter sut;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();

    registerFallbackValue(Uri.parse(url));
  });

  group(
    'POST',
    () {
      test(
        'Should call post with correct values',
        () async {
          when(
            () => client.post(
              any(),
              headers: any(named: 'headers'),
            ),
          ).thenAnswer(
            (_) async => Response('{}', 200),
          );

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
          final body = {'any_key': 'any_value'};

          when(
            () => client.post(any(),
                headers: any(named: 'headers'), body: any(named: 'body')),
          ).thenAnswer(
            (_) async => Response('{}', 200),
          );

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
    },
  );
}
