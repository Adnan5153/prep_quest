import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../domain/entities/translation_entity.dart';

class TranslationEntry {
  const TranslationEntry({required this.key, required this.value});

  final String key;
  final String value;
}

final activeLocaleProvider =
    StateProvider<LocaleTag>((Ref ref) => LocaleTag.english);

final translationsListProvider =
    FutureProvider.family<List<TranslationEntry>, LocaleTag>(
        (Ref ref, LocaleTag locale) async {
  final List<TranslationEntity> entries =
      await ref.watch(translationRepositoryProvider).listByLocale(locale);
  return entries
      .map((TranslationEntity e) => TranslationEntry(key: e.key, value: e.value))
      .toList();
});

final translationsCoverageProvider =
    FutureProvider<TranslationCoverage>((Ref ref) {
  return ref.watch(translationRepositoryProvider).coverage();
});
