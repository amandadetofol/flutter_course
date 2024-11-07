import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';

class GetxSplashScreenPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  var _navigateTo = RxString('');

  GetxSplashScreenPresenter({required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    await Future.delayed(Duration(seconds: 2));

    final account = await loadCurrentAccount.load();

    if (account != null && account.token != 'error') {
      _navigateTo.value = '/surveys';
    } else {
      _navigateTo.value = '/login';
    }
  }
}
