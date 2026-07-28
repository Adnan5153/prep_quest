import 'dart:math';

abstract class Ulid {
  const Ulid._();

  static const String _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  static final Random _random = Random.secure();

  static String generate({DateTime? time}) {
    final DateTime now = time ?? DateTime.now().toUtc();
    final int timestamp = now.millisecondsSinceEpoch;

    final StringBuffer buffer = StringBuffer();

    int ts = timestamp;
    for (int i = 9; i >= 0; i--) {
      buffer.write(_alphabet[ts % 32]);
      ts ~/= 32;
    }

    for (int i = 0; i < 16; i++) {
      buffer.write(_alphabet[_random.nextInt(32)]);
    }

    return buffer.toString();
  }

  static DateTime? timestamp(String ulid) {
    if (ulid.length < 10) return null;
    int ts = 0;
    for (int i = 0; i < 10; i++) {
      final int idx = _alphabet.indexOf(ulid[i]);
      if (idx < 0) return null;
      ts = ts * 32 + idx;
    }
    return DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true);
  }
}
