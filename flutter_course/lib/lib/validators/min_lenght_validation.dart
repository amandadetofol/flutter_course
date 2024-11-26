import 'package:equatable/equatable.dart';
import 'package:flutter_course/lib/validators/validators.dart';

import '../presentation/presenter/protocols/validation.dart';

class MinLenghtValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final int size;

  const MinLenghtValidation({
    required this.field,
    required this.size,
  });

  @override
  ValidationError? validate(Map input) {
    String? value = input[field];

    return (value?.length ?? 0) >= size ? null : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [
        field,
        size,
      ];
}
