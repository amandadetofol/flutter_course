import 'package:flutter_course/lib/validators/validators.dart';

class ValidationBuilder {
  static final ValidationBuilder _instance = ValidationBuilder._internal();
  late String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._internal();

  factory ValidationBuilder(String fieldName) {
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(field: fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation());
    return this;
  }

  List<FieldValidation> build() => validations;
}
