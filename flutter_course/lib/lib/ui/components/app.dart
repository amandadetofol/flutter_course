import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course/lib/ui/components/app_theme_data.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: '4Dev',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        presenter: LoginPresenterImpl(),
      ),
    );
  }
}

class LoginPresenterImpl implements LoginPresenter {
  final StreamController<bool> _form = StreamController<bool>();
  final StreamController<bool> _load = StreamController<bool>();
  final StreamController<String> _passwordErrorController =
      StreamController<String>();
  final StreamController<String> _mainErrorController =
      StreamController<String>();
  final StreamController<String> _emailErrorController =
      StreamController<String>();

  @override
  Stream<String?> get passwordErrorStream => _passwordErrorController.stream;

  @override
  Stream<String?> get emailErrorStream => _emailErrorController.stream;

  @override
  Stream<bool?> get isValidFormStream => _form.stream;

  @override
  void validateEmail(String email) {}

  @override
  void validatePassword(String password) {}

  @override
  Future<void>? auth() async {}

  @override
  Stream<bool?> get isLoadingStream => _load.stream;

  @override
  Stream<String?> get mainErrorStream => _mainErrorController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement isFormValidStream
  Stream<bool?> get isFormValidStream => throw UnimplementedError();
}
