import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;
  late ValidationComposite sut;

  void mockValidation1(String? value) {
    when(() => validation1.field).thenReturn('other_field');

    when(
      () => validation1.validate(
        any(),
      ),
    ).thenReturn(value);
  }

  void mockValidation2(String? value) {
    when(() => validation2.field).thenReturn('any_field');
    when(
      () => validation2.validate(
        any(),
      ),
    ).thenReturn(value);
  }

  void mockValidation3(String? value) {
    when(() => validation3.field).thenReturn('other_field');
    when(
      () => validation3.validate(
        any(),
      ),
    ).thenReturn(value);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    mockValidation2('');

    validation3 = FieldValidationSpy();
    mockValidation3(null);

    sut = ValidationComposite(validations: [
      validation1,
      validation2,
      validation3,
    ]);
  });

  test('Should return null if all validations return null or empty', () {
    final error = sut.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, null);
  });

  test('Should return first error', () {
    mockValidation1('error 1');
    mockValidation2('error 2');
    mockValidation3('error 3');

    final error = sut.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, 'error 2');
  });
}
