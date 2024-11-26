import 'package:faker/faker.dart';
import 'package:flutter_course/lib/presentation/presenter/protocols/validation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MinLenghtValidation sut;

  setUp(() {
    sut = const MinLenghtValidation(
      field: 'any_field',
      size: 5,
    );
  });

  test('Should return error if value is empty', () {
    var formData = {
      'any_field': '',
    };
    var error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    var formData = {
      'any_field': null,
    };
    var error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less then min size', () {
    var formData = {
      'any_field': faker.randomGenerator.string(4, min: 1),
    };
    var error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return null if string is equal to min size', () {
    var formData = {
      'any_field': faker.randomGenerator.string(5, min: 5),
    };
    var error = sut.validate(formData);
    expect(error, null);
  });

  test('Should return null if string is more to min size', () {
    var formData = {
      'any_field': faker.randomGenerator.string(10, min: 5),
    };
    var error = sut.validate(formData);
    expect(error, null);
  });
}
