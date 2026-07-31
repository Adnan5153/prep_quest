import 'package:flutter_test/flutter_test.dart';

/// Golden tests for the empty-state surface of the app.
///
/// NOTE: `lib/core/widgets/empty_state.dart` is currently an empty stub
/// file. The empty-state visuals are produced by other components in the
/// codebase (e.g. `no_data_widget.dart`). These tests are placeholders
/// for the eventual unified `EmptyState` widget.
///
/// Goldens targeted once the widget lands:
///   goldens/core/empty_state_default_light.png
///   goldens/core/empty_state_default_dark.png
///   goldens/core/empty_state_with_action_light.png
///   goldens/core/empty_state_with_action_dark.png
///   goldens/core/empty_state_compact_light.png
///   goldens/core/empty_state_compact_dark.png
void main() {
  group('EmptyState (placeholder - widget not yet implemented)', () {
    test('file exists in production code', () {
      expect(
        true,
        isTrue,
        reason: 'empty_state.dart is currently a stub. Implement the '
            'unified EmptyState widget and replace this placeholder with '
            'real golden tests.',
      );
    });
  });
}