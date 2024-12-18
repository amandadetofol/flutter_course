import 'package:flutter_course/lib/ui/helpers/helpers.dart';

abstract class LoginPresenter {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool?> get isFormValidStream;
  Stream<bool?> get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void>? auth();
  void dispose();
  void goToSignUp();
}
