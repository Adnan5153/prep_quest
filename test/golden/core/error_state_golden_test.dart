import 'package:flutter_test/flutter_test.dart';

/// Golden tests for the error-state surface of the app.
///
/// NOTE: `lib/core/widgets/error_state.dart` is currently an empty stub
/// file. The error-state visuals are produced by other components in
/// the codebase (e.g. `error_banner.dart`, `network_error_widget.dart`).
/// These tests are placeholders for the eventual unified `ErrorState`
/// widget.
///
/// Goldens targeted once the widget lands:
///   goldens/core/error_state_default_light.png
///   goldens/core/error_state_default_dark.png
///   goldens/core/error_state_with_action_light.png
///   goldens/core/error_state_with_action_dark.png
///   goldens/core/error_state_network_light.png
///   goldens/core/error_state_network_dark.png
void main() {
  group('ErrorState (placeholder - widget not yet implemented)', () {
    test('file exists in production code', () {
      expect(
        true,
        isTrue,
        reason: 'error_state.dart is currently a stub. Implement the '
            'unified ErrorState widget and replace this placeholder with '
            'real golden tests.',
      );
    });
  });
}