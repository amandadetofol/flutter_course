import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(
      field: 'any_field',
      valueToCompare: 'any_value',
    );
  });

  test('Should return error if value is different from value to compare', () {
    var error = sut.validate('other_value');
    expect(error, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    var error = sut.validate('any_value');
    expect(error, null);
  });
}
