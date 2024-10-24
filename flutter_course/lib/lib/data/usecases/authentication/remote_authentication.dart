import 'package:flutter_course/lib/data/model/remote_account_model.dart';
import 'package:flutter_course/lib/domain/helpers/domain_error.dart';

import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/authentication.dart';
import '../../http/http_client.dart';
import '../../http/http_error.dart';
import '../../model/models.dart';

class RemoteAuthentication implements Authentication {
  final ClientHttp httpClient;
  final String url;
  final String method;

  RemoteAuthentication({
    required this.url,
    required this.httpClient,
    required this.method,
  });

  @override
  Future<AccountEntity>? auth(
      {required AuthenticationParameters parameters}) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: method,
        body: RemoteAuthenticationParameters.fromDomain(parameters).toJson(),
      );

      if (httpResponse != null) {
        return RemoteAccountModel.fromJson(httpResponse).toEntity();
      } else {
        throw DomainError.unexpected;
      }
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}
