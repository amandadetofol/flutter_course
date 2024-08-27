import 'dart:convert';

import 'package:http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<Map?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
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
  }

  Map? _handleResponse({required Response response}) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
