import '../../../domain/domain.dart';
import '../../http/http_client.dart';

class RemoteAddAccount {
  final ClientHttp httpClient;
  final String url;
  final String method;

  RemoteAddAccount({
    required this.url,
    required this.httpClient,
    required this.method,
  });

  Future<AccountEntity?> add({required AddAccountParams parameters}) async {
    final body = RemoteAddAccountParameters.fromDomain(parameters).toJson();
    await httpClient.request(url: url, method: 'post', body: body);
    return null;
  }
}

class RemoteAddAccountParameters {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParameters({
    required this.email,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParameters.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParameters(
          email: params.email,
          name: params.name,
          password: params.password,
          passwordConfirmation: params.passwordConfirmation);

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
