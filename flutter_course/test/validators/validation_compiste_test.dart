import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_course/lib/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({required this.validations});

  @override
  String? validate({String? field, String? value}) {
    return null;
  }
}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;
  late ValidationComposite sut;

  void mockValidation1(String? value) {
    when(() => validation1.field).thenReturn('any_field');

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
    when(() => validation3.field).thenReturn('any_field');
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
}
