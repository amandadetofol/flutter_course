import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation();
  });

  test('Should return null if email is empty', () {
    var formData = {
      'email': '',
    };

    var error = sut.validate(formData);
    expect(error, null);
  });

  test('Should return null if email is null', () {
    var formData = {
      'email': null,
    };
    var error = sut.validate(formData);
    expect(error, null);
  });

  test('Should return error if email invalid', () {
    var formData = {
      'email': 'any_email',
    };
    var error = sut.validate(formData);
    expect(error, ValidationError.invalidField);
  });

  test('Should return error if email is valid', () {
    var formData = {
      'email': 'email@email.com',
    };
    var error = sut.validate(formData);
    expect(error, null);
  });

  test('Should  return null onm invalid case', () {
    var formData = {};
    var error = sut.validate(formData);
    expect(error, null);
  });
}
