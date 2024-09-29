import '../../../../presentation/presentation.dart';
import '../../usecases/usecases.dart';
import 'login_validation_factory.dart';

StreamLoginPresenter makePresenter() {
  return StreamLoginPresenter(
    makeRemoteAuthentication(),
    validation: makeValidators(),
  );
}
