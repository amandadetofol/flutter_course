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
  test('Should return null if all validations return null or empty', () {
    final validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('any_field');
    when(
      () => validation1.validate(any()),
    ).thenReturn(null);

    final validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    when(
      () => validation2.validate(any()),
    ).thenReturn('');

    final sut = ValidationComposite(validations: [
      validation1,
      validation2,
    ]);

    final error = sut.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, null);
  });
}
