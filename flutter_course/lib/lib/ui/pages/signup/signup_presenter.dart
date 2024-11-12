import '../../helpers/errors/ui_error.dart';

abstract class SignUpPresenter {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get nameErrorController;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get passwordConfirmationErrorController;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
}
