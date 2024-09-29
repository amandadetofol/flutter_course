import 'package:flutter_course/lib/main/builders/validation_builder.dart';

import '../../../../validators/validators.dart';

ValidationComposite makeValidators() {
  return ValidationComposite(validations: makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder('email').required().email().build(),
    ...ValidationBuilder('password').required().build(),
  ];
}
