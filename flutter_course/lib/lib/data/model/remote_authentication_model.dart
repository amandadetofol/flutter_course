import '../../domain/usecases/authentication.dart';

class RemoteAuthenticationParameters {
  final String email;
  final String password;

  RemoteAuthenticationParameters({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParameters.fromDomain(
          AuthenticationParameters entity) =>
      RemoteAuthenticationParameters(
        email: entity.email,
        password: entity.secret,
      );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
