import 'dart:async';

import 'protocols/validation.dart';

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream
      .map(
        (state) => state.emailError,
      )
      .distinct();

  Stream<bool?> get isFormValidStream => _controller.stream
      .map(
        (state) => state.isFormValid,
      )
      .distinct();

  Stream<String?> get passwordErrorStream => _controller.stream
      .map(
        (state) => state.passwordError,
      )
      .distinct();

  StreamLoginPresenter({
    required this.validation,
  });

  void validateEmail(String email) {
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _state.email = email;
    _controller.add(_state);
  }

  void validatePassword(String password) {
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );
    _state.password = password;
    _controller.add(_state);
  }
}

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;

  bool? get isFormValid =>
      emailError == null &&
      passwordError == null &&
      (email?.isNotEmpty ?? false) &&
      (password?.isNotEmpty ?? false);
}
