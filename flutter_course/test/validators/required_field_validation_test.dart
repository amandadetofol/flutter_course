import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation(field: 'any_field');
  });

  test(
    'should return null if value is not empty',
    () {
      var formData = {
        'any_field': 'any_value',
      };

      var fieldError = sut.validate(formData);
      expect(fieldError, null);
    },
  );

  test(
    'should return error message if value is null',
    () {
      var formData = {
        'any_field': null,
      };
      var fieldError = sut.validate(formData);
      expect(fieldError, ValidationError.requiredField);
    },
  );

  test(
    'should return error message if value is empty',
    () {
      var formData = {
        'any_field': '',
      };

      var fieldError = sut.validate(formData);
      expect(fieldError, ValidationError.requiredField);
    },
  );
}
