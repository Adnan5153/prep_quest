import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_accessibility.dart';
import '../../domain/usecases/update_language.dart';
import '../../domain/usecases/update_notifications.dart';
import '../../domain/usecases/update_privacy.dart';
import '../../domain/usecases/update_theme.dart';
import '../../domain/usecases/update_settings.dart';

// ---------------------------------------------------------------------------
// Layer wiring
// ---------------------------------------------------------------------------

/// Singleton in-memory data source. Swap for a Hive-backed source in
/// production by overriding this provider in the service locator.
final Provider<SettingsLocalDataSource> settingsLocalDataSourceProvider =
    Provider<SettingsLocalDataSource>((Ref ref) {
  return MockSettingsLocalDataSource();
});

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>((Ref ref) {
  final SettingsLocalDataSource local =
      ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(local);
});

final Provider<GetSettings> getSettingsUseCaseProvider =
    Provider<GetSettings>((Ref ref) {
  return GetSettings(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdateSettings> updateSettingsUseCaseProvider =
    Provider<UpdateSettings>((Ref ref) {
  return UpdateSettings(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdateTheme> updateThemeUseCaseProvider =
    Provider<UpdateTheme>((Ref ref) {
  return UpdateTheme(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdateLanguage> updateLanguageUseCaseProvider =
    Provider<UpdateLanguage>((Ref ref) {
  return UpdateLanguage(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdateNotifications> updateNotificationsUseCaseProvider =
    Provider<UpdateNotifications>((Ref ref) {
  return UpdateNotifications(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdatePrivacy> updatePrivacyUseCaseProvider =
    Provider<UpdatePrivacy>((Ref ref) {
  return UpdatePrivacy(ref.watch(settingsRepositoryProvider));
});

final Provider<UpdateAccessibility> updateAccessibilityUseCaseProvider =
    Provider<UpdateAccessibility>((Ref ref) {
  return UpdateAccessibility(ref.watch(settingsRepositoryProvider));
});

// ---------------------------------------------------------------------------
// State + controller
// ---------------------------------------------------------------------------

enum SettingsStatus { initial, loading, ready, saving, error }

class SettingsState {
  const SettingsState({
    required this.status,
    required this.settings,
    this.errorMessage,
    this.lastSavedAtIso,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      status: SettingsStatus.initial,
      settings: null,
    );
  }

  final SettingsStatus status;
  final SettingsEntity? settings;
  final String? errorMessage;

  /// ISO timestamp of the last successful persistence. Used by the
  /// snackbar listener to deduplicate messages.
  final String? lastSavedAtIso;

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsEntity? settings,
    String? errorMessage,
    String? lastSavedAtIso,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSavedAtIso: lastSavedAtIso ?? this.lastSavedAtIso,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController({
    required GetSettings getSettings,
    required UpdateSettings updateSettings,
    required UpdateTheme updateTheme,
    required UpdateLanguage updateLanguage,
    required UpdateNotifications updateNotifications,
    required UpdatePrivacy updatePrivacy,
    required UpdateAccessibility updateAccessibility,
  })  : _getSettings = getSettings,
        _updateSettings = updateSettings,
        _updateTheme = updateTheme,
        _updateLanguage = updateLanguage,
        _updateNotifications = updateNotifications,
        _updatePrivacy = updatePrivacy,
        _updateAccessibility = updateAccessibility,
        super(SettingsState.initial());

  final GetSettings _getSettings;
  final UpdateSettings _updateSettings;
  final UpdateTheme _updateTheme;
  final UpdateLanguage _updateLanguage;
  final UpdateNotifications _updateNotifications;
  final UpdatePrivacy _updatePrivacy;
  final UpdateAccessibility _updateAccessibility;

  Future<void> load() async {
    state = state.copyWith(status: SettingsStatus.loading, clearError: true);
    try {
      final SettingsEntity entity = await _getSettings();
      state = state.copyWith(
        status: SettingsStatus.ready,
        settings: entity,
      );
    } on Object catch (e) {
      state = state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Persists a single-field update by routing through the dedicated
  /// use case. All single-field updates ultimately resolve to the full
  /// [UpdateSettings] use case, but having dedicated overloads keeps
  /// the call-sites tidy and analytics-friendly.
  Future<void> _persistField(
    Future<SettingsEntity> Function(SettingsEntity current) mutator,
  ) async {
    final SettingsEntity? current = state.settings;
    if (current == null) return;
    state = state.copyWith(status: SettingsStatus.saving, clearError: true);
    try {
      final SettingsEntity saved = await mutator(current);
      state = state.copyWith(
        status: SettingsStatus.ready,
        settings: saved,
        lastSavedAtIso: DateTime.now().toIso8601String(),
      );
    } on Object catch (e) {
      state = state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateTheme(AppThemeMode mode) =>
      _persistField((SettingsEntity current) async {
        final SettingsEntity next = current.copyWith(themeMode: mode);
        return _updateTheme(mode)
            .then((_) => _updateSettings(next));
      });

  Future<void> updateLanguage(AppLanguage language) =>
      _persistField((SettingsEntity current) async {
        final SettingsEntity next = current.copyWith(language: language);
        return _updateLanguage(language)
            .then((_) => _updateSettings(next));
      });

  Future<void> updateNotifications(NotificationPreferences next) =>
      _persistField((SettingsEntity current) async {
        final SettingsEntity merged = current.copyWith(notifications: next);
        return _updateNotifications(next)
            .then((_) => _updateSettings(merged));
      });

  Future<void> updatePrivacy(PrivacyPreferences next) =>
      _persistField((SettingsEntity current) async {
        final SettingsEntity merged = current.copyWith(privacy: next);
        return _updatePrivacy(next)
            .then((_) => _updateSettings(merged));
      });

  Future<void> updateAccessibility(AccessibilityPreferences next) =>
      _persistField((SettingsEntity current) async {
        final SettingsEntity merged = current.copyWith(accessibility: next);
        return _updateAccessibility(next)
            .then((_) => _updateSettings(merged));
      });

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final StateNotifierProvider<SettingsController, SettingsState>
    settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((Ref ref) {
  return SettingsController(
    getSettings: ref.watch(getSettingsUseCaseProvider),
    updateSettings: ref.watch(updateSettingsUseCaseProvider),
    updateTheme: ref.watch(updateThemeUseCaseProvider),
    updateLanguage: ref.watch(updateLanguageUseCaseProvider),
    updateNotifications: ref.watch(updateNotificationsUseCaseProvider),
    updatePrivacy: ref.watch(updatePrivacyUseCaseProvider),
    updateAccessibility: ref.watch(updateAccessibilityUseCaseProvider),
  );
});
// ignore_for_file: prefer_initializing_formals