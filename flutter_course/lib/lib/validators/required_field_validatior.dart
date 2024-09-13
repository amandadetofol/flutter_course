import 'package:flutter_course/lib/validators/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation({required this.field});

  @override
  String? validate(String? value) {
    return (value?.isEmpty ?? false || value == '' || value == null)
        ? 'Campo obrigatório.'
        : null;
  }
}
