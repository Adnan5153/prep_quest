import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../../../shared/providers/admin_host_providers.dart';
import '../../../../shared/routing/admin_routes.dart';
import '../../domain/entities/auth_session.dart';
import '../providers/auth_provider.dart';

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.allowedRoles,
  });

  final String label;
  final IconData icon;
  final String route;
  final List<AdminRole> allowedRoles;
}

const List<_NavItem> _items = <_NavItem>[
  _NavItem(
    label: AdminStrings.navDashboard,
    icon: Icons.dashboard_outlined,
    route: AdminRoutes.dashboard,
    allowedRoles: <AdminRole>[
      AdminRole.viewer,
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
  _NavItem(
    label: AdminStrings.navWorlds,
    icon: Icons.public_outlined,
    route: AdminRoutes.worlds,
    allowedRoles: <AdminRole>[
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
  _NavItem(
    label: AdminStrings.navThemes,
    icon: Icons.palette_outlined,
    route: AdminRoutes.themes,
    allowedRoles: <AdminRole>[
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
  _NavItem(
    label: AdminStrings.navAssets,
    icon: Icons.image_outlined,
    route: AdminRoutes.assets,
    allowedRoles: <AdminRole>[
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
    ],
  ),
  _NavItem(
    label: AdminStrings.navTranslations,
    icon: Icons.translate_outlined,
    route: AdminRoutes.translations,
    allowedRoles: <AdminRole>[
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
  _NavItem(
    label: AdminStrings.navEvents,
    icon: Icons.event_outlined,
    route: AdminRoutes.events,
    allowedRoles: <AdminRole>[
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
    ],
  ),
  _NavItem(
    label: AdminStrings.navRewards,
    icon: Icons.emoji_events_outlined,
    route: AdminRoutes.rewards,
    allowedRoles: <AdminRole>[
      AdminRole.author,
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
    ],
  ),
  _NavItem(
    label: AdminStrings.navActivity,
    icon: Icons.history_outlined,
    route: AdminRoutes.activity,
    allowedRoles: <AdminRole>[
      AdminRole.reviewer,
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
  _NavItem(
    label: AdminStrings.navUsers,
    icon: Icons.people_outline,
    route: AdminRoutes.users,
    allowedRoles: <AdminRole>[AdminRole.admin],
  ),
  _NavItem(
    label: AdminStrings.navSettings,
    icon: Icons.settings_outlined,
    route: AdminRoutes.settings,
    allowedRoles: <AdminRole>[
      AdminRole.publisher,
      AdminRole.admin,
      AdminRole.auditor,
    ],
  ),
];

class AdminShellScreen extends ConsumerWidget {
  const AdminShellScreen({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  bool _matchesPrefix(String prefix, String path) {
    if (prefix == AdminRoutes.root) return path == AdminRoutes.root;
    return path == prefix || path.startsWith('$prefix/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState auth = ref.watch(authStateProvider);
    final AdminRole role = auth.session?.role ?? AdminRole.viewer;
    final List<_NavItem> visible =
        _items.where((_NavItem n) => n.allowedRoles.contains(role)).toList();

    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final String activeRoute = visible
        .where((_NavItem n) => _matchesPrefix(n.route, location))
        .map((_NavItem n) => n.route)
        .followedBy(<String>[location])
        .firstWhere((String r) => true);

    return Scaffold(
      body: Row(
        children: <Widget>[
          _Sidebar(
            items: visible,
            activeRoute: activeRoute,
            userEmail: auth.session?.email ?? '',
            userRole: role,
          ),
          Expanded(
            child: Container(
              color: scheme.surfaceContainerHighest,
              child: Column(
                children: <Widget>[
                  _TopBar(role: role),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.activeRoute,
    required this.userEmail,
    required this.userRole,
  });

  final List<_NavItem> items;
  final String activeRoute;
  final String userEmail;
  final AdminRole userRole;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: AdminSpacing.sidebarExpanded,
      decoration: BoxDecoration(
        color: AdminPalette.graphite,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.lg),
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AdminPalette.accent,
                    borderRadius: BorderRadius.circular(AdminRadius.sm),
                  ),
                  child: const Icon(Icons.layers, color: Colors.white, size: 18),
                ),
                const SizedBox(width: AdminSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'PrepQuest',
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Admin',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
              children: <Widget>[
                for (final _NavItem item in items)
                  _SidebarItem(
                    item: item,
                    selected: item.route == activeRoute,
                    onTap: () => context.go(item.route),
                  ),
              ],
            ),
          ),
          const _ExitAdminButton(),
          _SidebarFooter(email: userEmail, role: userRole),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color background = widget.selected
        ? AdminPalette.accent.withValues(alpha: 0.18)
        : _hover
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.transparent;
    final Color foreground =
        widget.selected ? Colors.white : Colors.white.withValues(alpha: 0.78);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AdminSpacing.md,
            vertical: AdminSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AdminRadius.sm),
          ),
          child: Row(
            children: <Widget>[
              Icon(widget.item.icon, color: foreground, size: 18),
              const SizedBox(width: AdminSpacing.sm),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foreground,
                        fontWeight:
                            widget.selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter({required this.email, required this.role});

  final String email;
  final AdminRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.md),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 14,
            backgroundColor: AdminPalette.accent,
            child: Text(
              email.isNotEmpty ? email[0].toUpperCase() : '?',
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: AdminSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role.wire.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AdminPalette.accentMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout, color: Colors.white70, size: 18),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).signOut();
              if (context.mounted) context.go(AdminRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}

class _ExitAdminButton extends ConsumerWidget {
  const _ExitAdminButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VoidCallback? exit = ref.watch(adminExitCallbackProvider);
    if (exit == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AdminSpacing.sm,
        0,
        AdminSpacing.sm,
        AdminSpacing.sm,
      ),
      child: OutlinedButton.icon(
        onPressed: exit,
        icon: const Icon(Icons.open_in_new, size: 16),
        label: const Text('Exit admin'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          minimumSize: const Size.fromHeight(36),
          padding: const EdgeInsets.symmetric(
            horizontal: AdminSpacing.md,
            vertical: AdminSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.sm),
          ),
          textStyle: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.role});

  final AdminRole role;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: AdminSpacing.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Authoring workspace',
            style: theme.textTheme.titleSmall,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AdminSpacing.sm,
              vertical: AdminSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AdminPalette.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AdminRadius.pill),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AdminPalette.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AdminSpacing.xs),
                Text(
                  'Connected',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AdminPalette.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AdminSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AdminSpacing.sm,
              vertical: AdminSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AdminRadius.pill),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              role.wire.toUpperCase(),
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
