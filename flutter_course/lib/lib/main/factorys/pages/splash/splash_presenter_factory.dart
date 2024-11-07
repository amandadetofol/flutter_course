import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/ui/pages/splash/splash.dart';

import '../../usecases/load_current_account/load_current_account.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashScreenPresenter(
      loadCurrentAccount: makeLocalLoadCurrentAccount());
}
