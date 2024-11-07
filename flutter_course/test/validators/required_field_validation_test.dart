import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return null if value is not empty',
    () {
      final sut = RequiredFieldValidation(field: 'any_field');
      var fieldError = sut.validate('any_value');
      expect(fieldError, null);
    },
  );

  test(
    'should return error message if value is null',
    () {
      final sut = RequiredFieldValidation(field: 'any_field');
      var fieldError = sut.validate(null);
      expect(fieldError, 'Campo obrigatório.');
    },
  );

  test(
    'should return error message if value is empty',
    () {
      final sut = RequiredFieldValidation(field: 'any_field');
      var fieldError = sut.validate('');
      expect(fieldError, 'Campo obrigatório.');
    },
  );
}
