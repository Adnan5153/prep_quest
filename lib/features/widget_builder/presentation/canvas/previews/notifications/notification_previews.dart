import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/widgets/notification_badge.dart';

/// Simple preview used by the widget builder for [NotificationBadge].
class NotificationBadgePreview extends StatelessWidget {
  const NotificationBadgePreview({super.key, required this.provider});

  final Object provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 48, height: 48, child: Center(child: Icon(AppIcons.notification))),
          const SizedBox(width: 12),
          const NotificationBadge(count: 3),
          const SizedBox(width: 24),
          const SizedBox(width: 48, height: 48, child: Center(child: Icon(AppIcons.notification))),
          const SizedBox(width: 12),
          const NotificationBadge(count: 120),
          const SizedBox(width: 24),
          const SizedBox(width: 48, height: 48, child: Center(child: Icon(AppIcons.notification))),
          const SizedBox(width: 12),
          const NotificationBadge(count: 0),
        ],
      ),
    );
  }
}
