import 'dart:async';

import 'package:flutter_course/lib/domain/usecases/usecases.dart';

import '../../domain/helpers/domain_error.dart';
import '../../ui/pages/pages.dart';
import 'protocols/validation.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  final _controller = StreamController<LoginState>.broadcast();
  final _state = LoginState();

  @override
  Stream<String?> get emailErrorStream => _controller.stream
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
  Stream<String?> get passwordErrorStream => _controller.stream
      .map(
        (state) => state.passwordError,
      )
      .distinct();
  @override
  Stream<String?> get mainErrorStream => _controller.stream
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
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _state.email = email;
    _controller.add(_state);
  }

  @override
  void validatePassword(String password) {
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
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
      } else {
        _state.mainError = DomainError.unexpected.description;
        _state.isLoading = false;
      }
    } on DomainError catch (error) {
      _state.mainError = error.description;
      _state.isLoading = false;
    }

    _controller.add(_state);
  }

  @override
  void dispose() {
    _controller.close();
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
