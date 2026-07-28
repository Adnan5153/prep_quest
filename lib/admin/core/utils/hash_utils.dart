import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;

abstract class HashUtils {
  const HashUtils._();

  static String sha256OfString(String input) {
    final List<int> bytes = utf8.encode(input);
    return crypto.sha256.convert(bytes).toString();
  }

  static String sha256OfJson(Object? value) {
    final String encoded = jsonEncode(value);
    return sha256OfString(encoded);
  }

  static String shortHash(String fullHash) {
    if (fullHash.length <= 10) return fullHash;
    return fullHash.substring(0, 10);
  }
}
