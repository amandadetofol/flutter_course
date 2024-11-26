import 'package:flutter_course/lib/domain/helpers/helpers.dart';
import 'package:flutter_course/lib/domain/usecases/usecases.dart';
import 'package:flutter_course/lib/presentation/presenter/protocols/validation.dart';
import 'package:get/get.dart';

import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/signup/signup_presenter.dart';

class GetXSignUpPresenter implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final Rx<UIError?> _emailError = Rx<UIError?>(null);
  final Rx<UIError?> _mainError = Rx<UIError?>(null);
  final Rx<UIError?> _nameError = Rx<UIError?>(null);
  final Rx<UIError?> _passwordError = Rx<UIError?>(null);
  final Rx<UIError?> _passwordConfirmationError = Rx<UIError?>(null);
  final Rx<String?> _navigateTo = Rx<String?>(null);

  final RxBool _isFormValid = false.obs;
  final RxBool _isLoading = false.obs;
  String _email = "";
  String _name = "";
  String _password = "";
  String _passwordConfirmation = "";

  GetXSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

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

  @override
  Future<void> signUp() async {
    _isLoading.value = true;
    try {
      final account = await addAccount.addAccount(
        parameters: AddAccountParams(
          email: _email,
          name: _name,
          password: _password,
          passwordConfirmation: _passwordConfirmation,
        ),
      );

      if (account != null) {
        await saveCurrentAccount.save(account);
        _navigateTo.value = "/surveys";
        _isLoading.value = false;
      } else {
        _isLoading.value = false;
        _mainError.value = UIError.unexpected;
      }
    } on DomainError catch (error) {
      _isLoading.value = false;
      switch (error) {
        case DomainError.unexpected:
          _mainError.value = UIError.unexpected;
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
      }
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String password) {
    _passwordConfirmation = password;
    _passwordConfirmationError.value = _validateField('password');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };

    final error = validation.validate(
      field: field,
      input: formData,
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
  void goToLogin() {
    _navigateTo.value = '/login';
  }
}
