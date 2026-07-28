import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

/// Horizontal "OR" divider used between primary and social actions.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.label = 'OR'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
        ),
      ],
    );
  }
}