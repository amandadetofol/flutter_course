import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity>? auth({
    required AuthenticationParameters parameters,
  });
}

class AuthenticationParameters extends Equatable {
  final String email;
  final String secret;

  const AuthenticationParameters({
    required this.email,
    required this.secret,
  });

  @override
  List<Object?> get props => [
        email,
        secret,
      ];
}
