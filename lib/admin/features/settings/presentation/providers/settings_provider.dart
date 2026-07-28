import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/admin_settings.dart';

class SettingsController extends StateNotifier<AdminSettings> {
  SettingsController()
      : super(const AdminSettings(
          environment: 'staging',
          requireMfa: true,
          requireReview: true,
          enableTelemetry: true,
          enableCrashReports: false,
          assetCdnBaseUrl: 'https://cdn.prepquest.app/v1',
        ));

  void update(AdminSettings next) {
    state = next;
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AdminSettings>(
  (Ref ref) => SettingsController(),
);
