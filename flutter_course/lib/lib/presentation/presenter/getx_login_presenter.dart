import 'dart:async';

import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';
import '../../ui/pages/pages.dart';
import 'protocols/validation.dart';

class GetXSLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String _email;
  String _password;

  final _emailError = RxString('');
  final _passwordError = RxString('');
  final _mainError = RxString('');
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;

  @override
  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool?> get isLoadingStream => _isLoading.stream;

  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String?> get mainErrorStream => _mainError.stream;

  GetXSLoginPresenter(
    this._email,
    this._password,
    this.authentication, {
    required this.validation,
  });

  @override
  void validateEmail(String email) {
    _emailError.value = validation.validate(
          field: 'email',
          value: email,
        ) ??
        '';
    _email = email;
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _passwordError.value = validation.validate(
          field: 'password',
          value: password,
        ) ??
        '';
    _password = password;
    _validateForm();
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;

    try {
      await authentication.auth(
        parameters: AuthenticationParameters(
          email: _email,
          secret: _password,
        ),
      );
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }

    _isLoading.value = false;
  }

  @override
  void dispose() {}

  void _validateForm() {
    _isFormValid.value = _emailError.value == '' &&
        _passwordError.value == '' &&
        (_email.isNotEmpty) &&
        (_password.isNotEmpty);
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
