import 'package:faker/faker.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/ui/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late GetXSignUpPresenter sut;
  late ValidationSpy validation;
  late String email;
  late String name;
  late String password;

  mockValidation(String field, ValidationError? value) {
    when(
      () => validation.validate(
        field: field,
        value: any(named: 'value'),
      ),
    ).thenReturn(value);
  }

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    name = faker.person.name();
    validation = ValidationSpy();
    sut = GetXSignUpPresenter(validation: validation);
  });

  group('e-mail tests', () {
    test('Shouldcall validation with correct email', () {
      sut.validateEmail(email);

      verify(() {
        validation.validate(
          field: 'email',
          value: email,
        );
      }).called(1);
    });

    test('Should emit invalid field error if email is invalid', () {
      mockValidation('email', ValidationError.invalidField);

      sut.validateEmail(email);
      sut.validateEmail(email);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, UIError.invalidField);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });

    test('Should emit null if email is empty', () {
      mockValidation('email', ValidationError.requiredField);

      sut.validateEmail(email);
      sut.validateEmail(email);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, UIError.requiredField);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });

    test('Should emit null if validation succeeds', () {
      mockValidation('email', null);

      sut.validateEmail(email);
      sut.validateEmail(email);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, null);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });
  });

  group('name tests', () {
    test('Shouldcall validation with correct name', () {
      sut.validateName(name);

      verify(() {
        validation.validate(
          field: 'name',
          value: name,
        );
      }).called(1);
    });

    test('Should emit null if name is empty', () {
      mockValidation('name', ValidationError.requiredField);

      sut.validateName(email);
      sut.validateName(email);

      sut.nameErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, UIError.requiredField);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });

    test('Should emit null if validation succeeds', () {
      mockValidation('name', null);

      sut.validateName(name);
      sut.validateName(name);

      sut.nameErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, null);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });
  });

  group('password tests', () {
    test('Shouldcall validation with correct password', () {
      sut.validatePassword(password);

      verify(() {
        validation.validate(
          field: 'password',
          value: password,
        );
      }).called(1);
    });

    test('Should emit null if password is empty', () {
      mockValidation('password', ValidationError.requiredField);

      sut.validatePassword(password);
      sut.validatePassword(password);

      sut.passwordErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, UIError.requiredField);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });

    test('Should emit null if validation succeeds', () {
      mockValidation('password', null);

      sut.validatePassword(password);
      sut.validatePassword(password);

      sut.passwordErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, null);
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    });
  });
}
