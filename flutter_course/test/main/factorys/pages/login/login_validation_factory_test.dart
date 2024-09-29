import 'package:flutter_course/lib/main/factorys/pages/pages.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return correct validations', () {
    final validations = makeLoginValidations();
    expect(
      validations,
      [
        const RequiredFieldValidation(field: 'email'),
        EmailValidation(),
        const RequiredFieldValidation(field: 'senha'),
      ],
    );
  });
}
