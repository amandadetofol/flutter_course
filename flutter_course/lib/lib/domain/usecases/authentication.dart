import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    required AuthenticationParameters parameters,
  });
}

class AuthenticationParameters {
  final String email;
  final String secret;

  AuthenticationParameters({
    required this.email,
    required this.secret,
  });
}
