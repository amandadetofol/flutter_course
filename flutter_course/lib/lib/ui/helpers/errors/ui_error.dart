import '../i18n/resources.dart';

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
        return R.translations.unexpected;
      case UIError.invalidCredentials:
        return R.translations.invalidCredentials;
      case UIError.requiredField:
        return R.translations.requiredField;
      case UIError.invalidField:
        return R.translations.invalidField;
    }
  }
}
