import 'package:equatable/equatable.dart';
import 'package:flutter_course/lib/validators/validators.dart';

import '../presentation/presenter/protocols/validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final String inputToCompare;

  const CompareFieldsValidation({
    required this.field,
    required this.inputToCompare,
  });

  @override
  List<Object?> get props => [
        field,
        inputToCompare,
      ];

  @override
  ValidationError? validate(Map input) {
    String value = input[field];
    String valueToCompare = input[inputToCompare];
    return (value == valueToCompare) ? null : ValidationError.invalidField;
  }
}
