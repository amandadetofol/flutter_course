import '../presentation/presenter/protocols/validation.dart';
import 'field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({required this.validations});

  @override
  ValidationError? validate({String? field, required Map input}) {
    if (field == null || !input.containsKey(field)) return null;

    ValidationError? error;
    var value = input[field];

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
