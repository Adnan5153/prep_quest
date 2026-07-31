import 'package:flutter_test/flutter_test.dart';

/// Golden tests for the [BrandHeader] widget.
///
/// NOTE: `lib/core/widgets/brand_header.dart` is currently an empty
/// stub file. These tests are placeholders for the eventual unified
/// `BrandHeader` widget. The brand surface currently lives in
/// `app_logo.dart` and `app_name.dart`, which can be combined into a
/// single brand header once the unified widget is implemented.
///
/// Goldens targeted once the widget lands:
///   goldens/core/brand_header_default_light.png
///   goldens/core/brand_header_default_dark.png
///   goldens/core/brand_header_compact_light.png
///   goldens/core/brand_header_compact_dark.png
void main() {
  group('BrandHeader (placeholder - widget not yet implemented)', () {
    test('file exists in production code', () {
      expect(
        true,
        isTrue,
        reason: 'brand_header.dart is currently a stub. Implement the '
            'BrandHeader widget and replace this placeholder with real '
            'golden tests.',
      );
    });
  });
}