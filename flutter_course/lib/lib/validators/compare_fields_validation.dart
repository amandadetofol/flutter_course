import 'package:equatable/equatable.dart';
import 'package:flutter_course/lib/validators/validators.dart';

import '../presentation/presenter/protocols/validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final String valueToCompare;

  const CompareFieldsValidation({
    required this.field,
    required this.valueToCompare,
  });

  @override
  List<Object?> get props => [
        field,
        valueToCompare,
      ];

  @override
  ValidationError? validate(String? value) {
    return (value == valueToCompare) ? null : ValidationError.invalidField;
  }
}
