import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../router.dart';

/// Thin dispatcher that forwards a deep-linked bookmark tap to the
/// appropriate destination screen, while preserving a "back to
/// bookmarks" leading affordance.
class BookmarkDetailScreen extends StatelessWidget {
  const BookmarkDetailScreen({
    super.key,
    required this.forwardRoute,
    required this.params,
  });

  /// Route name to forward to (e.g. `AppRoutes.lessonReader`).
  final String forwardRoute;

  /// Query parameters forwarded verbatim.
  final Map<String, String> params;

  @override
  Widget build(BuildContext context) {
    // Defer to next frame so the dispatcher doesn't push twice.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context.goNamed(
        forwardRoute,
        queryParameters: Map<String, String>.from(params),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.bookmarks),
        ),
        title: const Text('Opening bookmark...'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}