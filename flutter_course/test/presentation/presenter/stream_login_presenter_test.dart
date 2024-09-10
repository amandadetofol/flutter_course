import 'package:faker/faker.dart';
import 'package:flutter_course/lib/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late Validation validation;
  late String email;
  late StreamLoginPresenter sut;

  mockValidation(String field, String value) {
    when(
      () => validation.validate(
        field: field,
        value: any(named: 'value'),
      ),
    ).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    email = faker.internet.email();
    sut = StreamLoginPresenter(validation: validation);
  });

  test(
    'Should call validation with correct email',
    () {
      sut.validateEmail(email);

      verify(
        () => validation.validate(
          field: 'email',
          value: email,
        ),
      ).called(1);
    },
  );

  test(
    'Should emit email error if validation fails',
    () {
      mockValidation('email', 'error');

      sut.validateEmail(email);
      sut.validateEmail(email);

      sut.emailErrorStream.listen(
        (error) {
          expectAsync1(
            (error) {
              expect(error, 'error');
            },
          );
        },
      );

      sut.isFormValidStream.listen(
        (isValid) {
          expectAsync1(
            (isValid) {
              expect(isValid, false);
            },
          );
        },
      );
    },
  );
}
