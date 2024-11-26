import 'dart:async';

import 'package:flutter_course/lib/domain/usecases/usecases.dart';

import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/pages.dart';
import 'protocols/validation.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  final _controller = StreamController<LoginState>.broadcast();
  final _state = LoginState();

  @override
  Stream<String?> get navigateToStream => _controller.stream
      .map(
        (state) => state.path,
      )
      .distinct();

  @override
  Stream<UIError?> get emailErrorStream => _controller.stream
      .map(
        (state) => state.emailError,
      )
      .distinct();

  @override
  Stream<bool?> get isFormValidStream => _controller.stream
      .map(
        (state) => state.isFormValid,
      )
      .distinct();

  @override
  Stream<bool?> get isLoadingStream => _controller.stream
      .map(
        (state) => state.isLoading,
      )
      .distinct();

  @override
  Stream<UIError?> get passwordErrorStream => _controller.stream
      .map(
        (state) => state.passwordError,
      )
      .distinct();

  @override
  Stream<UIError?> get mainErrorStream => _controller.stream
      .map(
        (state) => state.mainError,
      )
      .distinct();

  StreamLoginPresenter(
    this.authentication, {
    required this.validation,
    required this.saveCurrentAccount,
  });

  @override
  void validateEmail(String email) {
    _state.emailError = _validateField(
      'email',
      email,
    );
    _state.email = email;
    _controller.add(_state);
  }

  @override
  void validatePassword(String password) {
    _state.passwordError = _validateField(
      'password',
      password,
    );
    _state.password = password;
    _controller.add(_state);
  }

  @override
  Future<void> auth() async {
    _state.isLoading = true;
    _controller.add(_state);

    try {
      var accountEntity = await authentication.auth(
        parameters: AuthenticationParameters(
          email: _state.email ?? '',
          secret: _state.password ?? '',
        ),
      );

      if (accountEntity != null) {
        await saveCurrentAccount.save(accountEntity);
        _state.path = '/surveys';
      } else {
        _state.mainError = UIError.unexpected;
        _state.isLoading = false;
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.unexpected:
          _state.mainError = UIError.unexpected;
        default:
          _state.mainError = UIError.invalidCredentials;
      }
      _state.isLoading = false;
    }

    _controller.add(_state);
  }

  @override
  void dispose() {
    _controller.close();
  }

  UIError? _validateField(String field, String value) {
    final error = validation.validate(
      field: field,
      value: value,
    );

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  @override
  void goToSignUp() {
    _state.path = '/signup';
  }
}

class LoginState {
  String? email;
  String? password;
  UIError? emailError;
  UIError? passwordError;
  bool? isLoading;
  UIError? mainError;
  String? path;

  bool? get isFormValid =>
      emailError == null &&
      passwordError == null &&
      (email != null) &&
      (password != null);
}
