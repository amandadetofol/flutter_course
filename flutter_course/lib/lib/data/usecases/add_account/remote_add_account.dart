import '../../../domain/domain.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../http/http_client.dart';
import '../../http/http_error.dart';

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

    try {
      final response =
          await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;

        case HttpError.forbidden:
          throw DomainError.emailInUse;

        default:
          throw DomainError.unexpected;
      }
    }
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
