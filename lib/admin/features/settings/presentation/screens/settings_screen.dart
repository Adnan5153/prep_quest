import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../domain/entities/admin_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AdminSettings s = ref.watch(settingsControllerProvider);
    final SettingsController controller =
        ref.read(settingsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Settings', style: theme.textTheme.displayMedium),
          const SizedBox(height: AdminSpacing.sm),
          Text(
            'Workspace-wide configuration. Saved to the runtime config document and broadcast to clients.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _SectionCard(
                    title: 'Environment',
                    children: <Widget>[
                      RadioGroup<EnvironmentTag>(
                        groupValue: _environmentTag(s.environment),
                        onChanged: (EnvironmentTag? v) {
                          if (v == null) return;
                          controller.update(s.copyWith(
                            environment: v == EnvironmentTag.production
                                ? 'production'
                                : 'staging',
                          ));
                        },
                        child: const Column(
                          children: <Widget>[
                            _RadioRow<EnvironmentTag>(
                              label: 'Production',
                              value: EnvironmentTag.production,
                            ),
                            _RadioRow<EnvironmentTag>(
                              label: 'Staging',
                              value: EnvironmentTag.staging,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Security',
                    children: <Widget>[
                      _SwitchRow(
                        label: 'Require MFA for every admin sign-in',
                        value: s.requireMfa,
                        onChanged: (bool v) =>
                            controller.update(s.copyWith(requireMfa: v)),
                      ),
                      _SwitchRow(
                        label: 'Require reviewer before publishing',
                        value: s.requireReview,
                        onChanged: (bool v) =>
                            controller.update(s.copyWith(requireReview: v)),
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Telemetry',
                    children: <Widget>[
                      _SwitchRow(
                        label: 'Send anonymized usage telemetry',
                        value: s.enableTelemetry,
                        onChanged: (bool v) =>
                            controller.update(s.copyWith(enableTelemetry: v)),
                      ),
                      _SwitchRow(
                        label: 'Forward crash reports to Sentry',
                        value: s.enableCrashReports,
                        onChanged: (bool v) =>
                            controller.update(s.copyWith(enableCrashReports: v)),
                      ),
                    ],
                  ),
                  _SectionCard(
                    title: 'Asset delivery',
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AdminSpacing.sm),
                        child: TextField(
                          controller: TextEditingController(text: s.assetCdnBaseUrl),
                          decoration: const InputDecoration(
                            labelText: 'CDN base URL',
                          ),
                          onSubmitted: (String v) => controller.update(
                            s.copyWith(assetCdnBaseUrl: v),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  EnvironmentTag _environmentTag(String env) {
    switch (env) {
      case 'production':
        return EnvironmentTag.production;
      default:
        return EnvironmentTag.staging;
    }
  }
}

enum EnvironmentTag { production, staging }

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AdminSpacing.lg),
      padding: const EdgeInsets.all(AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AdminSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Radio<T>(value: value),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
