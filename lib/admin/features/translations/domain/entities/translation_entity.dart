import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class TranslationEntity {
  const TranslationEntity({
    required this.key,
    required this.locale,
    required this.value,
    required this.updatedBy,
    required this.updatedAt,
    this.context,
  });

  final String key;
  final LocaleTag locale;
  final String value;
  final String? context;
  final String updatedBy;
  final DateTime updatedAt;

  TranslationEntity copyWith({
    String? key,
    LocaleTag? locale,
    String? value,
    String? context,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return TranslationEntity(
      key: key ?? this.key,
      locale: locale ?? this.locale,
      value: value ?? this.value,
      context: context ?? this.context,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@immutable
class TranslationCoverage {
  const TranslationCoverage({
    required this.total,
    required this.byLocale,
  });

  final int total;
  final Map<String, int> byLocale;
}

@immutable
class TranslationBundle {
  const TranslationBundle({
    required this.locale,
    required this.entries,
  });

  final LocaleTag locale;
  final List<TranslationEntity> entries;

  Map<String, String> asMap() =>
      <String, String>{for (final TranslationEntity e in entries) e.key: e.value};
}
