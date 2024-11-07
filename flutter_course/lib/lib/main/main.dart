import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course/lib/main/factorys/pages/splash/splash_page_factory.dart';
import 'package:flutter_course/lib/ui/components/components.dart';
import 'package:get/get.dart';

import 'factorys/pages/login/login_page_factory.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: '4Dev',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => makeSplashPage(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: () => makeLoginPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/surveys',
          page: () => const Scaffold(
            body: Text('Enquetes'),
          ),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
