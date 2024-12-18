import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(
        field: 'any_field', inputToCompare: 'other_field');
  });

  test('Should return error if value is different from value to compare', () {
    var formData = {
      'other_field': 'other_value',
      'any_field': 'any_value',
    };
    var error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    var formData = {
      'other_field': 'any_value',
      'any_field': 'any_value',
    };
    var error = sut.validate(formData);
    expect(error, null);
  });

  test('Should return null on invalid cases', () {
    var error1 = sut.validate({
      'other_field': 'any_value',
    });
    expect(error1, null);

    var error2 = sut.validate({
      'any_field': 'any_value',
    });
    expect(error2, null);

    var error3 = sut.validate({});
    expect(error3, null);
  });
}
