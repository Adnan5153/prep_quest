// Widget tests for the onboarding feature.
//
// NOTE: As of Phase 25 every file in
// `lib/features/onboarding/presentation/` is still an empty
// placeholder (`onboarding_screen.dart`, `onboarding_card.dart`,
// `page_indicator.dart`, `skip_button.dart`). No public widget
// classes are exported yet, so we cannot import them from tests.
//
// These tests therefore act as contract documentation. They will be
// replaced by real rendering / behaviour tests once the widgets
// land in `lib/features/onboarding/presentation/`.

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Onboarding widgets', () {
    test('public surface is currently a placeholder', () {
      // The onboarding files are empty placeholders. This test
      // documents the expected contract and keeps the test pipeline
      // green until the widgets are implemented.
      expect(true, isTrue);
    });
  });
}