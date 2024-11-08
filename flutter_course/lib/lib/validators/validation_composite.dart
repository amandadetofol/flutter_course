import '../presentation/presenter/protocols/validation.dart';
import 'field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({required this.validations});

  @override
  ValidationError? validate({String? field, String? value}) {
    ValidationError? error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
