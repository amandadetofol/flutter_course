import 'package:faker/faker.dart';
import 'package:flutter_course/lib/domain/domain.dart';
import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/ui/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class AccountEntityMock extends Mock implements AccountEntity {}

class AddAccountParamsSpy extends Mock implements AddAccountParams {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetXSignUpPresenter sut;
  late AddAccountSpy addAccountSpy;
  late ValidationSpy validation;
  late String token;
  late String email;
  late String name;
  late String password;
  late AccountEntityMock accountEntityMock;
  late SaveCurrentAccountSpy saveCurrentAccount;

  mockSignUp(AccountEntity? entity) {
    when(
      () => addAccountSpy.addAccount(
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer(
      (_) async =>
          entity ??
          AccountEntity(
            token: token,
          ),
    );
  }

  mockSignUpError(DomainError error) {
    when(
      () => addAccountSpy.addAccount(
        parameters: any(named: 'parameters'),
      ),
    ).thenThrow(error);
  }

  mockValidation(String field, ValidationError? value) {
    when(
      () => validation.validate(
        field: field,
        input: any(named: 'input'),
      ),
    ).thenReturn(value);
  }

  void mockSaveCurrentAccount() {
    when(() => saveCurrentAccount.save(any()))
        .thenAnswer((_) async => AccountEntity(token: token));
  }

  void mockSaveCurrentAccountError() {
    when(
      () => saveCurrentAccount.save(
        any(),
      ),
    ).thenThrow(DomainError.unexpected);
  }

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    name = faker.person.name();
    token = faker.guid.guid();

    addAccountSpy = AddAccountSpy();
    validation = ValidationSpy();
    accountEntityMock = AccountEntityMock();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetXSignUpPresenter(
      validation: validation,
      addAccount: addAccountSpy,
      saveCurrentAccount: saveCurrentAccount,
    );

    registerFallbackValue(accountEntityMock);
    registerFallbackValue(
      AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: password),
    );
    mockSignUp(accountEntityMock);
    mockSaveCurrentAccount();
  });
  test('Should emit correct events on EmailInUseError', () async {
    mockSignUpError(DomainError.emailInUse);

    final isLoadingFuture = expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    final mainErrorFuture = expectLater(
      sut.mainErrorStream,
      emits(UIError.emailInUse),
    );

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    await isLoadingFuture;
    await mainErrorFuture;
  });

  test('Should amit correct events on UnexpectedError', () async {
    mockSignUpError(DomainError.unexpected);

    final isLoadingFuture = expectLater(
      sut.isLoadingStream,
      emitsInAnyOrder([true, false]),
    );

    final mainErrorFuture = expectLater(
      sut.mainErrorStream,
      emits(UIError.unexpected),
    );

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    await isLoadingFuture;
    await mainErrorFuture;
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInAnyOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(password);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(() {
      addAccountSpy.addAccount(
          parameters: AddAccountParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: password,
      ));
    }).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(() {
      saveCurrentAccount.save(accountEntityMock);
    }).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    sut.mainErrorStream.listen(
      (error) {
        expectAsync1(
          (error) {
            expect(error, UIError.unexpected);
          },
        );
      },
    );

    sut.isLoadingStream.listen(
      (error) {
        expectAsync1(
          (error) {
            emitsInOrder([false, true]);
          },
        );
      },
    );
  });

  test('Should emit correct events on SignUp success', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test(
    'Should navigate to surveys on authentication success',
    () async {
      sut.validateEmail(email);
      sut.validateName(name);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(password);

      final navigateToStream =
          expectLater(sut.navigateToStream, emitsThrough('/surveys'));

      await sut.signUp();

      sut.navigateToStream.listen(
        (page) {
          expectAsync1(
            (page) {
              expect(page, '/surveys');
            },
          );
        },
      );

      await Future.wait([
        navigateToStream,
      ]);
    },
  );

  group('e-mail tests', () {
    test('Shouldcall validation with correct email', () {
      sut.validateEmail(email);

      verify(() {
        validation.validate(
          field: 'email',
          input: {
            'name': '',
            'email': email,
            'password': '',
            'passwordConfirmation': ''
          },
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
          input: {
            'name': name,
            'email': '',
            'password': '',
            'passwordConfirmation': ''
          },
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
          input: {
            'name': '',
            'email': '',
            'password': password,
            'passwordConfirmation': ''
          },
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

  group('password confirmation tests', () {
    test('Should call validation with correct passwordConfirmation', () {
      sut.validatePasswordConfirmation(password);

      verify(() {
        validation.validate(
          field: 'password',
          input: {
            'name': '',
            'email': '',
            'password': '',
            'passwordConfirmation': password
          },
        );
      }).called(1);
    });

    test('Should emit null if passwordConfirmation is empty', () {
      mockValidation('passwordConfirmation', ValidationError.requiredField);

      sut.validatePasswordConfirmation(password);
      sut.validatePasswordConfirmation(password);

      sut.passwordConfirmationErrorStream.listen(
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
      mockValidation('passwordConfirmation', null);

      sut.validatePasswordConfirmation(password);
      sut.validatePasswordConfirmation(password);

      sut.passwordConfirmationErrorStream.listen(
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
