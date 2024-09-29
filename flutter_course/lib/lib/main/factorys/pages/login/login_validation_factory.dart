import '../../../../validators/validators.dart';

ValidationComposite makeValidators() {
  return ValidationComposite(validations: [
    RequiredFieldValidation(field: 'email'),
    EmailValidation(),
    RequiredFieldValidation(field: 'senha'),
  ]);
}
