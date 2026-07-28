import 'package:flutter/material.dart';

import 'ai_loading_constants.dart';

/// Loading-specific extensions over the Flutter framework.
extension AiLoadingContext on BuildContext {
  /// Resolves the loading palette from the current theme brightness.
  LoadingPalette get loadingPalette =>
      LoadingPalette.from(Theme.of(this).brightness == Brightness.dark);
}
