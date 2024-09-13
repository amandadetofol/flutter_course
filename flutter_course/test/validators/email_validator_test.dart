import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return null if email is empty', () {
    final sut = EmailValidation();
    var error = sut.validate('');
    expect(error, null);
  });

  test('Should return null if email is null', () {
    final sut = EmailValidation();
    var error = sut.validate(null);
    expect(error, null);
  });

  test('Should return error if email invalid', () {
    final sut = EmailValidation();
    var error = sut.validate('any_email');
    expect(error, 'E-mail inválido');
  });

  test('Should return error if email is valid', () {
    final sut = EmailValidation();
    var error = sut.validate('email@email.com');
    expect(error, null);
  });
}
