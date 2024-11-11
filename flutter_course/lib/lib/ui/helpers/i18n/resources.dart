import 'package:flutter/widgets.dart';
import 'package:flutter_course/lib/ui/helpers/i18n/strings/strings.dart';

class R {
  static Translations translations = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        translations = PtBr();
        break;
    }
  }
}
