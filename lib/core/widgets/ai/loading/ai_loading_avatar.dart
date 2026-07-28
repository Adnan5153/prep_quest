import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../ai_constants.dart';
import 'ai_loading_constants.dart';
import 'ai_loading_extensions.dart';
import 'ai_loading_text.dart';

/// Square skeleton block sized to the AI avatar footprint. Used as the
/// leading element of an [AiLoadingCard] and any future list-style
/// loading state.
class AiLoadingAvatar extends StatelessWidget {
  const AiLoadingAvatar({super.key, this.controller, this.palette, this.size});

  final AnimationController? controller;
  final LoadingPalette? palette;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double resolved = size ?? AiConstants.compactAvatarSize + 8;
    final LoadingPalette p = palette ?? context.loadingPalette;
    return AiLoadingText(
      controller: controller,
      palette: p,
      width: resolved,
      height: resolved,
      radius: AppRadius.md,
    );
  }
}
