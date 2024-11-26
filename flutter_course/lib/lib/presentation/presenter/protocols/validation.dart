abstract class Validation {
  ValidationError? validate({
    String field,
    required Map input,
  });
}

enum ValidationError {
  requiredField,
  invalidField,
  minLenghtCharacters,
}
