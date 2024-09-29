import '../../../../validators/validators.dart';

ValidationComposite makeValidators() {
  return ValidationComposite(validations: makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation(field: 'email'),
    EmailValidation(),
    RequiredFieldValidation(field: 'senha'),
  ];
}
