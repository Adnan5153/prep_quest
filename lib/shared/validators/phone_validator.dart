/// Phone-number validator.
///
/// Accepts Bangladeshi mobile numbers when prefixed with the country
/// code (+880) or the local leading zero (01). The validator ignores
/// spaces, dashes, and parentheses so users can paste numbers in
/// familiar formats.
class PhoneValidator {
  const PhoneValidator._();

  static final RegExp _bdPattern = RegExp(
    r'^(?:\+?880|0)1[3-9][0-9]{8}$',
  );

  static String normalize(String? input) {
    if (input == null) return '';
    return input.replaceAll(RegExp(r'[\s\-()]'), '');
  }

  static bool isValid(String? input) {
    final String normalized = normalize(input);
    if (normalized.isEmpty) return false;
    return _bdPattern.hasMatch(normalized);
  }
}
