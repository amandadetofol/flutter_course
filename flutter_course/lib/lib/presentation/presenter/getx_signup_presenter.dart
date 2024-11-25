import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_course/lib/presentation/presenter/protocols/validation.dart';
import 'package:get/get.dart';

import '../../ui/helpers/errors/ui_error.dart';

class GetXSignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;

  final Rx<UIError?> _emailError = Rx<UIError?>(null);
  final Rx<UIError?> _nameError = Rx<UIError?>(null);
  final Rx<UIError?> _passwordError = Rx<UIError?>(null);
  final Rx<UIError?> _passwordConfirmationError = Rx<UIError?>(null);
  final RxBool _isFormValid = false.obs;
  String _email = "";
  String _name = "";
  String _password = "";
  String _passwordConfirmation = "";

  GetXSignUpPresenter({
    required this.validation,
    required this.addAccount,
  });

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordError.stream;

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _email.isNotEmpty &&
        _nameError.value == null &&
        _name.isNotEmpty &&
        _passwordError.value == null &&
        _password.isNotEmpty &&
        _passwordConfirmationError.value == null &&
        _passwordConfirmation.isNotEmpty;
  }

  Future<void> signUp() async {
    await addAccount.addAccount(
        parameters: AddAccountParams(
      email: _email,
      name: _name,
      password: _password,
      passwordConfirmation: _passwordConfirmation,
    ));
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email', email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name', name);
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordConfirmation = password;
    _passwordConfirmationError.value = _validateField('password', password);
    _validateForm();
  }

  void validatePasswordConfirmation(String password) {
    _password = password;
    _passwordError.value = _validateField('password', password);
    _validateForm();
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
}
