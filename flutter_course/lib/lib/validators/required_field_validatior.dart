import 'package:equatable/equatable.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/field_validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation({required this.field});

  @override
  ValidationError? validate(String? value) {
    return (value?.isEmpty ?? false || value == '' || value == null)
        ? ValidationError.requiredField
        : null;
  }

  @override
  List<Object?> get props => [field];
}
