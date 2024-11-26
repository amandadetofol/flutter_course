import 'package:flutter_course/lib/presentation/presentation.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(Map input);
}
