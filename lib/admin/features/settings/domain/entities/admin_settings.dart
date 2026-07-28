import 'package:flutter/foundation.dart';

@immutable
class AdminSettings {
  const AdminSettings({
    required this.environment,
    required this.requireMfa,
    required this.requireReview,
    required this.enableTelemetry,
    required this.enableCrashReports,
    required this.assetCdnBaseUrl,
  });

  final String environment;
  final bool requireMfa;
  final bool requireReview;
  final bool enableTelemetry;
  final bool enableCrashReports;
  final String assetCdnBaseUrl;

  AdminSettings copyWith({
    String? environment,
    bool? requireMfa,
    bool? requireReview,
    bool? enableTelemetry,
    bool? enableCrashReports,
    String? assetCdnBaseUrl,
  }) {
    return AdminSettings(
      environment: environment ?? this.environment,
      requireMfa: requireMfa ?? this.requireMfa,
      requireReview: requireReview ?? this.requireReview,
      enableTelemetry: enableTelemetry ?? this.enableTelemetry,
      enableCrashReports: enableCrashReports ?? this.enableCrashReports,
      assetCdnBaseUrl: assetCdnBaseUrl ?? this.assetCdnBaseUrl,
    );
  }
}
