import 'package:flutter_course/lib/presentation/presenter/protocols/validation.dart';
import 'package:get/get.dart';

import '../../ui/helpers/errors/ui_error.dart';

class GetXSignUpPresenter {
  final Validation validation;
  final Rx<UIError?> _emailError = Rx<UIError?>(null);
  final RxBool _isFormValid = false.obs;
  String _email = "";

  GetXSignUpPresenter({required this.validation});

  Stream<UIError?> get emailErrorStream => _emailError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void _validateForm() {
    _isFormValid.value = _emailError.value == null && _email.isNotEmpty;
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email', email);
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
