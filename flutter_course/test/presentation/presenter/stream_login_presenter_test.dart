import 'package:faker/faker.dart';
import 'package:flutter_course/lib/domain/entities/entities.dart';
import 'package:flutter_course/lib/domain/helpers/domain_error.dart';
import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class AuthenticationSpy extends Mock implements Authentication {}

class AccountEntityStuby extends Mock {}

void main() {
  late Validation validation;
  late String email;
  late String password;
  late StreamLoginPresenter sut;
  late Authentication authentication;
  final String token = faker.guid.guid();
  late SaveCurrentAccount saveCurrentAccount;

  mockValidation(String field, String? value) {
    when(
      () => validation.validate(
        field: field,
        value: any(named: 'value'),
      ),
    ).thenReturn(value);
  }

  mockAuthentication(AccountEntity? entity) {
    when(
      () => authentication.auth(
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

  mockSaveCurrentAccount() {
    when(
      () => saveCurrentAccount.save(any()),
    ).thenAnswer((_) async => Future.value());
  }

  mockAuthenticationError(DomainError error) {
    when(
      () => authentication.auth(
        parameters: any(named: 'parameters'),
      ),
    ).thenThrow(error);
  }

  setUp(() {
    registerFallbackValue(const AuthenticationParameters(
      email: '',
      secret: '',
    ));

    registerFallbackValue(AccountEntity(token: token));

    saveCurrentAccount = SaveCurrentAccountSpy();

    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    email = faker.internet.email();
    password = faker.internet.password();
    sut = StreamLoginPresenter(
      authentication,
      validation: validation,
      saveCurrentAccount: saveCurrentAccount,
    );
    mockAuthentication(null);
    mockSaveCurrentAccount();
  });

  test(
    'Should call validation with correct email',
    () {
      sut.validateEmail(email);

      verify(
        () => validation.validate(
          field: 'email',
          value: email,
        ),
      ).called(1);
    },
  );

  test(
    'Should emit email error if validation fails',
    () {
      mockValidation('email', 'error');

      sut.validateEmail(email);
      sut.validateEmail(email);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'error');
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
    },
  );

  test(
    'Should emit null if validation succed',
    () {
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
    },
  );

  test(
    'Should call validation with correct password',
    () {
      sut.validatePassword(password);

      verify(
        () => validation.validate(
          field: 'password',
          value: password,
        ),
      ).called(1);
    },
  );

  test(
    'Should emit null if validation succed',
    () {
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
    },
  );

  test(
    'Should emit password error if validation fails',
    () {
      mockValidation('password', 'error');

      sut.validatePassword(password);
      sut.validatePassword(password);

      sut.passwordErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'error');
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
    },
  );

  test(
    'Should emit null if validation succed',
    () {
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
    },
  );

  test(
    'Should emit null if validation succed',
    () {
      mockValidation('email', 'error');

      sut.validateEmail(email);
      sut.validatePassword(password);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'error');
            },
          );
        },
      );

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
    },
  );

  test(
    'Should emit true in formValidation if validation succeeds',
    () async {
      final emailError = expectLater(sut.emailErrorStream, emits(null));
      final passwordError = expectLater(sut.passwordErrorStream, emits(null));
      final formValid =
          expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);
      await Future.wait([emailError]);
      sut.validatePassword(password);

      await Future.wait([
        passwordError,
        formValid,
      ]);
    },
    timeout: const Timeout(Duration(seconds: 5)),
  );

  test(
    'Should call authentication with correct values',
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        () => authentication.auth(
          parameters: AuthenticationParameters(
            email: email,
            secret: password,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'Should call saveCurrentAccount with correct AccountEntity',
    () async {
      final entity = AccountEntity(token: token);
      mockAuthentication(entity);
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        () => saveCurrentAccount.save(
          entity,
        ),
      ).called(1);
    },
  );

  test(
    'Should emit correct events on authentication success',
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      final loadingPresentation =
          expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();

      await Future.wait([loadingPresentation]);
    },
  );

  test(
    'Should emit correct events on invalid credentials error',
    () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      final loadingPresentation =
          expectLater(sut.isLoadingStream, emits(false));

      await sut.auth();

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'Credenciais inválidas.');
            },
          );
        },
      );

      await Future.wait([
        loadingPresentation,
      ]);
    },
  );

  test(
    'Should emit correct events on unexpected error',
    () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      final loadingPresentation =
          expectLater(sut.isLoadingStream, emits(false));

      await sut.auth();

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'Algo errado aconteceu.');
            },
          );
        },
      );

      await Future.wait([
        loadingPresentation,
      ]);
    },
  );

  test(
    'Should not emit events after dispose',
    () async {
      final neverEmits = expectLater(sut.emailErrorStream, emitsDone);

      sut.dispose();

      await Future.wait([
        neverEmits,
      ]);
    },
  );
}
