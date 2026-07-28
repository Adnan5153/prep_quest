import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

/// Loading-specific design tokens that don't yet exist on the global
/// `AppColors` / `AiConstants` surfaces.
class AiLoadingTokens {
  const AiLoadingTokens._();

  /// Minimum and maximum supported body line counts.
  static const int minBodyLineCount = 1;
  static const int maxBodyLineCount = 6;

  /// Clamps a caller-supplied [count] to the supported 1..6 range.
  static int clampBodyLineCount(int count) =>
      count.clamp(minBodyLineCount, maxBodyLineCount);

  /// Returns the per-line shimmer bar widths for a given [count].
  ///
  /// The first N−1 lines fill their parent width; the last line trails off
  /// so the body block looks like real paragraph text being typed.
  static List<double> bodyLineWidths(int count) {
    final int n = clampBodyLineCount(count);
    switch (n) {
      case 1:
        return const <double>[double.infinity];
      case 2:
        return const <double>[double.infinity, 220];
      case 3:
        return const <double>[double.infinity, double.infinity, 200];
      case 4:
        return const <double>[
          double.infinity,
          double.infinity,
          double.infinity,
          180,
        ];
      case 5:
        return const <double>[
          double.infinity,
          double.infinity,
          double.infinity,
          220,
          160,
        ];
      default:
        return const <double>[
          double.infinity,
          double.infinity,
          double.infinity,
          double.infinity,
          220,
          140,
        ];
    }
  }
}

/// Resolved colour pair used by every skeleton bar in the loading
/// subsystem. Reuses `AppColors` for the light-mode base/highlight and
/// `Colors.white` for the dark-mode pair.
class LoadingPalette {
  const LoadingPalette({required this.base, required this.highlight});

  final Color base;
  final Color highlight;

  factory LoadingPalette.from(bool isDark) {
    return LoadingPalette(
      base: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : AppColors.lightMuted.withValues(alpha: 0.12),
      highlight: isDark
          ? Colors.white.withValues(alpha: 0.12)
          : AppColors.lightMuted.withValues(alpha: 0.05),
    );
  }
}
