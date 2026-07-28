import 'package:flutter/material.dart';

import '../ai_error_state.dart';

class AiErrorStateActions extends StatelessWidget {
  const AiErrorStateActions({
    super.key,
    required this.layout,
    required this.primary,
    required this.secondary,
    required this.spacing,
  });

  final AiErrorStateActionLayout layout;
  final Widget? primary;
  final Widget? secondary;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (primary == null && secondary == null) {
      return const SizedBox.shrink();
    }
    if (primary != null && secondary == null) {
      return primary!;
    }
    if (primary == null && secondary != null) {
      return secondary!;
    }

    final List<Widget> pair = <Widget>[primary!, secondary!];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact =
            constraints.maxWidth <= 480 ||
            layout == AiErrorStateActionLayout.column;

        if (compact || layout == AiErrorStateActionLayout.column) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              pair[0],
              SizedBox(height: spacing),
              pair[1],
            ],
          );
        }

        if (layout == AiErrorStateActionLayout.wrap) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: spacing,
            children: pair,
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pair[0],
            SizedBox(width: spacing),
            pair[1],
          ],
        );
      },
    );
  }
}
