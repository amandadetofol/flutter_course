import 'package:flutter_course/lib/presentation/presenter/getx_login_presenter.dart';

import '../../usecases/usecases.dart';
import 'login_validation_factory.dart';

GetXSLoginPresenter makePresenter({
  required String email,
  required String password,
}) {
  return GetXSLoginPresenter(
    email,
    password,
    makeRemoteAuthentication(),
    validation: makeValidators(),
  );
}
