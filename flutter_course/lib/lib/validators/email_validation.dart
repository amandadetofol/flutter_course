import 'package:equatable/equatable.dart';

import 'field_validation.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  String get field => 'email';

  @override
  String? validate(String? value) {
    if (value == null || value == '') {
      return null;
    }

    var emailRegex = RegExp(
        r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\.[a-zA-Z]{2,})+$');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }

    return null;
  }

  @override
  List<Object?> get props => [field];
}
