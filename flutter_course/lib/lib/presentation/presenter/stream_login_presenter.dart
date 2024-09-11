import 'dart:async';

import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_course/lib/domain/usecases/usecases.dart';

import 'protocols/validation.dart';

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;

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

  Stream<bool?> get isLoadingStream => _controller.stream
      .map(
        (state) => state.isLoading,
      )
      .distinct();

  Stream<String?> get passwordErrorStream => _controller.stream
      .map(
        (state) => state.passwordError,
      )
      .distinct();

  Stream<String?> get mainErrorStream => _controller.stream
      .map(
        (state) => state.mainError,
      )
      .distinct();

  StreamLoginPresenter(
    this.authentication, {
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

  Future<void> auth() async {
    _state.isLoading = true;
    _controller.add(_state);

    try {
      await authentication.auth(
        parameters: AuthenticationParameters(
          email: _state.email ?? '',
          secret: _state.password ?? '',
        ),
      );
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }

    _state.isLoading = false;
    _controller.add(_state);
  }
}

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  bool? isLoading;
  String? mainError;

  bool? get isFormValid =>
      emailError == null &&
      passwordError == null &&
      (email?.isNotEmpty ?? false) &&
      (password?.isNotEmpty ?? false);
}
