abstract class SlugValidator {
  const SlugValidator._();

  static final RegExp _pattern = RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,62}[a-z0-9])?$');

  static bool isValid(String? input) {
    if (input == null || input.isEmpty) return false;
    return _pattern.hasMatch(input);
  }

  static String? validate(String? input) {
    if (input == null || input.isEmpty) return 'Required';
    if (!_pattern.hasMatch(input)) {
      return 'Lowercase letters, digits, and dashes only';
    }
    return null;
  }
}

abstract class TranslationKeyValidator {
  const TranslationKeyValidator._();

  static final RegExp _pattern = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$');

  static bool isValid(String? input) {
    if (input == null || input.isEmpty) return false;
    return _pattern.hasMatch(input);
  }

  static String? validate(String? input) {
    if (input == null || input.isEmpty) return 'Required';
    if (!_pattern.hasMatch(input)) {
      return 'Use dotted lowercase, e.g. lesson.greeting';
    }
    return null;
  }
}

abstract class EmailValidator {
  const EmailValidator._();

  static final RegExp _pattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static String? validate(String? input) {
    if (input == null || input.trim().isEmpty) return 'Required';
    if (!_pattern.hasMatch(input.trim())) return 'Invalid email';
    return null;
  }
}

abstract class RequiredValidator {
  const RequiredValidator._();

  static String? validate(String? input) {
    if (input == null || input.trim().isEmpty) return 'Required';
    return null;
  }
}

abstract class NumberRangeValidator {
  const NumberRangeValidator._();

  static String? validate(num? input, {num? min, num? max}) {
    if (input == null) return 'Required';
    if (min != null && input < min) return 'Must be ≥ $min';
    if (max != null && input > max) return 'Must be ≤ $max';
    return null;
  }
}
