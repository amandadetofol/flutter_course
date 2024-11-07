import 'dart:convert';

import 'package:flutter_course/lib/data/http/http_client.dart';
import 'package:flutter_course/lib/data/http/http_error.dart';
import 'package:http/http.dart';

class HttpAdapter implements ClientHttp {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?>? request({
    required String? url,
    required String? method,
    Map? body,
  }) async {
    if (method != null && url != null) {
      if (isValidMethod(method)) {
        final headers = {
          'content-type': 'application/json',
          'accept': 'application/json'
        };

        final response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: (body != null) ? jsonEncode(body) : null,
        );
        return _handleResponse(response: response);
      } else {
        throw HttpError.serverError;
      }
    } else {
      throw HttpError.serverError;
    }
  }

  bool isValidMethod(String method) => method == 'post';

  Map? _handleResponse({required Response response}) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      case 500:
        throw HttpError.serverError;
      default:
        return null;
    }
  }
}
