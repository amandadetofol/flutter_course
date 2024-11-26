import '../../helpers/errors/ui_error.dart';

abstract class SignUpPresenter {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get nameErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get passwordConfirmationErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get navigateToStream;

  Future<void> signUp();
  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
  void goToLogin();
}
