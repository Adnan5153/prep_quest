import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';

enum PlaygroundPreviewTileMode { light, dark, sideBySide }

class PlaygroundPreviewTile extends StatelessWidget {
  const PlaygroundPreviewTile({
    super.key,
    required this.mode,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.aspectRatio,
    this.borderRadius = 12,
  });

  final String mode;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve(mode);
    if (resolved == PlaygroundPreviewTileMode.light) {
      return _tile(Brightness.light, padding);
    }
    if (resolved == PlaygroundPreviewTileMode.dark) {
      return _tile(Brightness.dark, padding);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 480;
        final halfWidth = wide
            ? (constraints.maxWidth - AppSpacing.lg) / 2
            : null;
        final tiles = <Widget>[
          SizedBox(
            width: halfWidth,
            child: _tile(Brightness.light, padding, aspectRatio: aspectRatio),
          ),
          SizedBox(
            width: halfWidth,
            child: _tile(Brightness.dark, padding, aspectRatio: aspectRatio),
          ),
        ];
        return wide
            ? Row(children: tiles)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  tiles[0],
                  const SizedBox(height: AppSpacing.lg),
                  tiles[1],
                ],
              );
      },
    );
  }

  PlaygroundPreviewTileMode _resolve(String value) {
    switch (value) {
      case 'lightOnly':
        return PlaygroundPreviewTileMode.light;
      case 'darkOnly':
        return PlaygroundPreviewTileMode.dark;
      default:
        return PlaygroundPreviewTileMode.sideBySide;
    }
  }

  Widget _tile(
    Brightness brightness,
    EdgeInsetsGeometry padding, {
    double? aspectRatio,
  }) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    final background = brightness == Brightness.dark
        ? const Color(0xFF15151B)
        : const Color(0xFFF4F5F7);
    Widget body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Theme(
        data: theme,
        child: Center(child: child),
      ),
    );
    if (aspectRatio != null) {
      body = AspectRatio(aspectRatio: aspectRatio, child: body);
    }
    return body;
  }
}
