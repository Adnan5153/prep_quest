import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/users_provider.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<UserEntity>> users = ref.watch(usersListProvider);
    final AsyncValue<List<RoleDefinition>> roles =
        ref.watch(roleDefinitionsProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Users & roles', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Admin accounts, role assignments, MFA status. Roles gate sidebar items and write actions.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_outlined, size: 16),
                label: const Text('Invite user'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: users.when(
                    data: (List<UserEntity> list) => _UsersTable(users: list),
                    loading: () => const Center(
                        child: CircularProgressIndicator()),
                    error: (Object e, _) => Center(child: Text('Failed: $e')),
                  ),
                ),
                const SizedBox(width: AdminSpacing.lg),
                Expanded(
                  child: roles.when(
                    data: (List<RoleDefinition> list) =>
                        _RolesPanel(roles: list),
                    loading: () => const Center(
                        child: CircularProgressIndicator()),
                    error: (Object e, _) => Center(child: Text('Failed: $e')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTable extends ConsumerWidget {
  const _UsersTable({required this.users});

  final List<UserEntity> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.md),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text('User', style: theme.textTheme.labelSmall),
                ),
                SizedBox(
                  width: 110,
                  child: Text('Status', style: theme.textTheme.labelSmall),
                ),
                SizedBox(
                  width: 110,
                  child: Text('MFA', style: theme.textTheme.labelSmall),
                ),
                SizedBox(
                  width: 140,
                  child: Text('Last login', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Roles', style: theme.textTheme.labelSmall),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (BuildContext _, int _) =>
                  const Divider(height: 1),
              itemBuilder: (BuildContext c, int i) =>
                  _UserRow(user: users[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserRow extends ConsumerWidget {
  const _UserRow({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md, vertical: AdminSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.displayName, style: theme.textTheme.titleSmall),
                Text(user.email, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          SizedBox(
            width: 110,
            child: _StatusPill(status: user.status),
          ),
          SizedBox(
            width: 110,
            child: Row(
              children: <Widget>[
                Icon(
                  user.mfaEnrolled
                      ? Icons.verified_user_outlined
                      : Icons.no_encryption_outlined,
                  size: 14,
                  color: user.mfaEnrolled
                      ? AdminPalette.success
                      : AdminPalette.warning,
                ),
                const SizedBox(width: 4),
                Text(user.mfaEnrolled ? 'Enrolled' : 'Pending',
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(
              user.lastLoginAt == null
                  ? '—'
                  : DateFormat.yMMMd().add_Hm().format(user.lastLoginAt!),
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: user.roles
                  .map((AdminRole r) => _RolePill(role: r))
                  .toList(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, size: 16),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final UserStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = switch (status) {
      UserStatus.active => AdminPalette.success,
      UserStatus.disabled => AdminPalette.danger,
      UserStatus.pending => AdminPalette.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: tint.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: tint),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role});

  final AdminRole role;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Text(
        role.wire,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _RolesPanel extends StatelessWidget {
  const _RolesPanel({required this.roles});

  final List<RoleDefinition> roles;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Roles', style: theme.textTheme.titleMedium),
          const SizedBox(height: AdminSpacing.md),
          for (final RoleDefinition r in roles)
            Padding(
              padding: const EdgeInsets.only(bottom: AdminSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(r.displayName, style: theme.textTheme.titleSmall),
                  Text(r.description, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
