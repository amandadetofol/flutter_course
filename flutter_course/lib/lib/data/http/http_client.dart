abstract class ClientHttp {
  Future<Map?>? request({
    required String? url,
    required String? method,
    Map? body,
  }) async {}
}
