import '../presentation/presenter/protocols/validation.dart';
import 'field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({required this.validations});

  @override
  String? validate({String? field, String? value}) {
    String? error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty ?? false) {
        return error;
      }
    }

    if (error?.isEmpty ?? false) {
      return null;
    }

    return error;
  }
}
