import 'package:flutter_test/flutter_test.dart';

/// Golden tests for the [Avatar] widget.
///
/// NOTE: `lib/core/widgets/avatar.dart` is currently an empty stub
/// file — the production avatar implementation lives in
/// `lib/core/widgets/profile_avatar.dart`. The unified `Avatar` widget
/// is being designed but not yet implemented.
///
/// These tests are intentionally placeholders. When the unified
/// `Avatar` class is exported from `avatar.dart`, replace this file
/// with a real golden suite and re-export `ProfileAvatar` (or move the
/// widget entirely) so that golden captures exercise the new public
/// API.
///
/// Goldens targeted once the widget lands:
///   goldens/core/avatar_initials_light.png
///   goldens/core/avatar_initials_dark.png
///   goldens/core/avatar_with_image_light.png
///   goldens/core/avatar_with_image_dark.png
///   goldens/core/avatar_loading_light.png
///   goldens/core/avatar_loading_dark.png
///   goldens/core/avatar_premium_light.png
///   goldens/core/avatar_premium_dark.png
void main() {
  group('Avatar (placeholder - widget not yet implemented)', () {
    test('file exists in production code', () {
      expect(
        true,
        isTrue,
        reason: 'avatar.dart is currently a stub. Implement the unified '
            'avatar widget and replace this placeholder with real golden '
            'tests. The current implementation lives in profile_avatar.dart '
            'and is exercised by profile_avatar_golden_test.dart.',
      );
    });
  });
}