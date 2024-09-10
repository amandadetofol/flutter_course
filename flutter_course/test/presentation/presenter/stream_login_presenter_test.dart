import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream.map(
        (state) => state.emailError,
      );

  StreamLoginPresenter({
    required this.validation,
  });

  void validateEmail(String email) {
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _controller.add(_state);
  }
}

abstract class Validation {
  String? validate({
    String field,
    String value,
  });
}

void main() {
  late Validation validation;
  late String email;
  late StreamLoginPresenter sut;

  mockValidation(String field, String value) {
    when(
      () => validation.validate(
        field: field,
        value: any(named: 'value'),
      ),
    ).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    email = faker.internet.email();
    sut = StreamLoginPresenter(validation: validation);
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

      expectLater(
        sut.emailErrorStream,
        emits('error'),
      );

      sut.validateEmail(email);
    },
  );
}
