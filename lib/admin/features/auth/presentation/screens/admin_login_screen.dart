import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/routing/admin_routes.dart';
import '../../domain/entities/auth_session.dart';
import '../providers/auth_provider.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final TextEditingController _email = TextEditingController(text: 'admin@prepquest.app');
  final TextEditingController _password = TextEditingController(text: 'admin');
  final TextEditingController _mfa = TextEditingController(text: '123456');
  bool _busy = false;
  bool _showMfa = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _mfa.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      if (_showMfa) {
        await ref.read(authStateProvider.notifier).verifyMfa(_mfa.text);
      } else {
        await ref.read(authStateProvider.notifier)
            .signIn(_email.text, _password.text);
        if (mounted) {
          final AuthState s = ref.read(authStateProvider);
          if (s.status == AuthStatus.awaitingMfa) {
            setState(() => _showMfa = true);
          }
        }
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState state = ref.watch(authStateProvider);

    ref.listen<AuthState>(authStateProvider, (AuthState? previous, AuthState next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AdminRoutes.dashboard);
      }
      if (next.status == AuthStatus.awaitingMfa && mounted) {
        setState(() => _showMfa = true);
      }
    });

    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.all(AdminSpacing.xl),
            child: Padding(
              padding: const EdgeInsets.all(AdminSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.layers, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: AdminSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(AdminStrings.appName, style: theme.textTheme.titleLarge),
                            Text(AdminStrings.appTagline, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AdminSpacing.xl),
                  Text(
                    _showMfa ? AdminStrings.loginMfa : AdminStrings.loginTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AdminSpacing.xs),
                  Text(
                    AdminStrings.loginSubtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AdminSpacing.xl),
                  if (!_showMfa) ...<Widget>[
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: AdminStrings.loginEmail),
                    ),
                    const SizedBox(height: AdminSpacing.md),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: AdminStrings.loginPassword),
                    ),
                  ] else
                    TextField(
                      controller: _mfa,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Verification code',
                        hintText: '6-digit code',
                      ),
                    ),
                  if (state.errorMessage != null) ...<Widget>[
                    const SizedBox(height: AdminSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AdminSpacing.sm),
                      decoration: BoxDecoration(
                        color: AdminPalette.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AdminPalette.danger.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AdminPalette.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: AdminSpacing.xl),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
                      child: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_showMfa ? 'Verify' : AdminStrings.loginSignIn),
                    ),
                  ),
                  if (!_showMfa) ...<Widget>[
                    const SizedBox(height: AdminSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () async {
                              setState(() => _busy = true);
                              await ref
                                  .read(authStateProvider.notifier)
                                  .signIn('admin@prepquest.app', 'admin');
                              if (mounted) {
                                final AuthState s = ref.read(authStateProvider);
                                if (s.status == AuthStatus.awaitingMfa) {
                                  setState(() => _showMfa = true);
                                }
                                setState(() => _busy = false);
                              }
                            },
                      icon: const Icon(Icons.shield_outlined, size: 18),
                      label: const Text(AdminStrings.loginSso),
                    ),
                  ],
                  const SizedBox(height: AdminSpacing.lg),
                  Text(
                    'Demo accounts: admin@prepquest.app / author@ / reviewer@ / publisher@ / auditor@ / viewer@ — password: admin — MFA: 123456',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
