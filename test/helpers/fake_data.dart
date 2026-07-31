import 'package:flutter/material.dart';

import 'package:prep_quest/core/constants/app_spacing.dart';

/// Centralised fake data used across widget, repository, and provider
/// tests. Keeping these in one place avoids duplicate "fake user",
/// "fake session", and "fake quiz" definitions scattered through test
/// files.
class FakeData {
  const FakeData._();

  static const String testEmail = 'test.user@example.com';
  static const String testName = 'Test User';
  static const String testDistrict = 'Dhaka';
  static const String testPhone = '+8801700000000';
  static const String testPassword = 'Password123';

  static const Map<String, Object?> emptyJson = <String, Object?>{};

  /// Common set of widget paddings used in widget tests where the
  /// production token is needed.
  static const EdgeInsets defaultPadding = EdgeInsets.all(AppSpacing.md);
}
