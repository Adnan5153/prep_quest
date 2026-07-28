import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/admin_theme.dart';
import 'shared/routing/admin_router.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PrepQuest Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light(),
      darkTheme: AdminTheme.dark(),
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(adminRouterProvider),
    );
  }
}
