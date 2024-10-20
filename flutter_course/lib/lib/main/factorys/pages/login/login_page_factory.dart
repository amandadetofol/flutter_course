import 'package:flutter/material.dart';
import 'package:flutter_course/lib/main/factorys/pages/login/login_presenter_factory.dart';
import 'package:flutter_course/lib/ui/pages/login/login_page.dart';

Widget makeLoginPage() {
  return LoginPage(presenter: makePresenter());
}
