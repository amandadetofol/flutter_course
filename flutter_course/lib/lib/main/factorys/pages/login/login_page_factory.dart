import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/login/login_page.dart';

import 'login_presenter_factory.dart';

Widget makeLoginPage() {
  return LoginPage(presenter: makePresenter());
}
