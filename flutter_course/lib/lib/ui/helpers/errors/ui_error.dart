enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
}

extension DomainErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.unexpected:
        return 'Algo errado aconteceu.';
      case UIError.invalidCredentials:
        return 'Credenciais inválidas';
      case UIError.requiredField:
        return 'Campo obrigatório';
      case UIError.invalidField:
        return 'Campo inválido';
    }
  }
}
