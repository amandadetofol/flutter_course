import 'package:equatable/equatable.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';

import 'field_validation.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  String get field => 'email';

  @override
  ValidationError? validate(Map input) {
    String? value = input[field];
    if (value == null || value == '') {
      return null;
    }

    var emailRegex = RegExp(
        r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,})+$');
    if (!emailRegex.hasMatch(value)) {
      return ValidationError.invalidField;
    }

    return null;
  }

  @override
  List<Object?> get props => [field];
}
