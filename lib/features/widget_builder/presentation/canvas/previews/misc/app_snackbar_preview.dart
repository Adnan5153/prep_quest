import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../providers/widget_builder_provider.dart';

class AppSnackBarPreview extends StatelessWidget {
  const AppSnackBarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 760);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionLabel(text: 'Variants — tap to trigger'),
                  _TriggerGrid(),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Action Button'),
                  _ActionShowcase(),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Dismissible'),
                  _DismissibleShowcase(),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Floating'),
                  _BehaviorShowcase(floating: true),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Fixed'),
                  _BehaviorShowcase(floating: false),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeShowcase(
                    brightness: Brightness.light,
                    label: 'Light Theme',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _ThemeShowcase(
                    brightness: Brightness.dark,
                    label: 'Dark Theme',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _TriggerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _TriggerButton(
          label: 'Success',
          icon: Icons.check_circle_outline,
          onPressed: () =>
              AppSnackBar.showSuccess(context, 'Profile saved successfully.'),
        ),
        _TriggerButton(
          label: 'Error',
          icon: Icons.error_outline,
          onPressed: () => AppSnackBar.showError(
            context,
            'Unable to connect. Please check your network.',
          ),
        ),
        _TriggerButton(
          label: 'Warning',
          icon: Icons.warning_amber_outlined,
          onPressed: () =>
              AppSnackBar.showWarning(context, 'You have 2 unsaved changes.'),
        ),
        _TriggerButton(
          label: 'Information',
          icon: Icons.info_outline,
          onPressed: () =>
              AppSnackBar.showInfo(context, 'A new version is available.'),
        ),
        _TriggerButton(
          label: 'Neutral',
          icon: Icons.notifications_outlined,
          onPressed: () => AppSnackBar.showInfo(
            context,
            'New message in #general',
            title: 'New notification',
          ),
        ),
        _TriggerButton(
          label: 'With Retry',
          icon: Icons.refresh_rounded,
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar.error(
              context,
              'Sync failed. Try again.',
              action: SnackBarAction(label: 'Retry', onPressed: () {}),
            ),
          ),
        ),
      ],
    );
  }
}

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

class _ActionShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar(
              message: 'Item deleted.',
              action: SnackBarAction(label: 'Undo', onPressed: () {}),
            ),
          ),
          child: const Text('Undo'),
        ),
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar(
              message: 'Connection lost during upload.',
              variant: AppSnackBarVariant.error,
              action: SnackBarAction(label: 'Retry', onPressed: () {}),
            ),
          ),
          child: const Text('Retry on Error'),
        ),
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar.info(
              context,
              'Update ready to install.',
              action: SnackBarAction(label: 'Install', onPressed: () {}),
            ),
          ),
          child: const Text('Action on Info'),
        ),
      ],
    );
  }
}

class _DismissibleShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar(
              message: 'You can dismiss this notification.',
              showCloseButton: true,
              duration: const Duration(seconds: 10),
            ),
          ),
          child: const Text('With Close Button'),
        ),
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar.error(
              context,
              'Critical: storage almost full.',
              showCloseButton: true,
              duration: const Duration(seconds: 30),
            ),
          ),
          child: const Text('Long Error'),
        ),
      ],
    );
  }
}

class _BehaviorShowcase extends StatelessWidget {
  const _BehaviorShowcase({required this.floating});

  final bool floating;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar(
              message: floating
                  ? 'Floating snackbar with rounded corners and margin.'
                  : 'Fixed snackbar pinned to the bottom edge.',
              behavior: floating
                  ? SnackBarBehavior.floating
                  : SnackBarBehavior.fixed,
            ),
          ),
          child: Text(floating ? 'Show Floating' : 'Show Fixed'),
        ),
        OutlinedButton(
          onPressed: () => AppSnackBar.show(
            context,
            AppSnackBar.success(
              context,
              'Top-positioned floating snackbar.',
              location: AppSnackBarLocation.top,
            ),
          ),
          child: const Text('Top Floating'),
        ),
      ],
    );
  }
}

class _ThemeShowcase extends StatelessWidget {
  const _ThemeShowcase({required this.brightness, required this.label});

  final Brightness brightness;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _SectionLabel(text: label),
        Theme(
          data: Theme.of(context).copyWith(brightness: brightness),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: brightness == Brightness.dark
                  ? const Color(0xFF0B0F14)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () => AppSnackBar.show(
                    context,
                    AppSnackBar.success(context, 'Saved.'),
                  ),
                  child: const Text('Success'),
                ),
                OutlinedButton(
                  onPressed: () => AppSnackBar.show(
                    context,
                    AppSnackBar.error(context, 'Something went wrong.'),
                  ),
                  child: const Text('Error'),
                ),
                OutlinedButton(
                  onPressed: () => AppSnackBar.show(
                    context,
                    AppSnackBar.warning(context, 'Check your inputs.'),
                  ),
                  child: const Text('Warning'),
                ),
                OutlinedButton(
                  onPressed: () => AppSnackBar.show(
                    context,
                    AppSnackBar.info(context, 'Heads up.'),
                  ),
                  child: const Text('Info'),
                ),
                OutlinedButton(
                  onPressed: () => AppSnackBar.show(
                    context,
                    AppSnackBar.neutral(context, 'New update is live.'),
                  ),
                  child: const Text('Neutral'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
