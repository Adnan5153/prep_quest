import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../providers/notification_provider.dart';
import '../widgets/empty_notification.dart';
import '../widgets/notification_tile.dart';

/// Top-level notifications inbox screen.
class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(notificationControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NotificationViewState state =
        ref.watch(notificationControllerProvider);
    final NotificationController controller =
        ref.read(notificationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
        actions: <Widget>[
          if (state.unreadCount > 0)
            TextButton(
              onPressed: controller.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveBuilder.value<double>(
                context,
                mobile: double.infinity,
                tablet: 640,
                desktop: 800,
              ),
            ),
            child: state.items.isEmpty
                ? const EmptyNotification()
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final notification = state.items[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () {
                          controller.markRead(notification.id);
                        },
                        onDismiss: () => controller.remove(notification.id),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
