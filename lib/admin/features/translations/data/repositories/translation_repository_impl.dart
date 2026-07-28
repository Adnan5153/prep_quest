import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  TranslationRepositoryImpl() {
    _seed();
  }

  final Map<String, TranslationEntity> _entries = <String, TranslationEntity>{};
  final Set<String> _referencedKeys = <String>{};

  String _composite(String key, LocaleTag locale) => '${locale.code}::$key';

  void _seed() {
    final DateTime now = DateTime.now();
    final List<TranslationEntity> seed = <TranslationEntity>[
      TranslationEntity(
        key: 'app.title',
        locale: LocaleTag.english,
        value: 'PrepQuest',
        updatedBy: 'usr_admin',
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      TranslationEntity(
        key: 'app.title',
        locale: LocaleTag.bangla,
        value: 'প্রেপকোয়েস্ট',
        updatedBy: 'usr_admin',
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      TranslationEntity(
        key: 'playground.greeting',
        locale: LocaleTag.english,
        value: 'Welcome back',
        updatedBy: 'usr_admin',
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
      TranslationEntity(
        key: 'playground.greeting',
        locale: LocaleTag.bangla,
        value: 'স্বাগতম',
        updatedBy: 'usr_admin',
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.intro',
        locale: LocaleTag.english,
        value: 'Introduction to BCS',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.intro',
        locale: LocaleTag.bangla,
        value: 'বিসিএস পরিচিতি',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.intro.sub',
        locale: LocaleTag.english,
        value: 'Start your BCS journey here.',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.intro.sub',
        locale: LocaleTag.bangla,
        value: 'এখান থেকে আপনার বিসিএস যাত্রা শুরু করুন।',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.bangla',
        locale: LocaleTag.english,
        value: 'Bangla',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.bangla',
        locale: LocaleTag.bangla,
        value: 'বাংলা',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.bangla.sub',
        locale: LocaleTag.english,
        value: 'Master Bangla fundamentals.',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.english',
        locale: LocaleTag.english,
        value: 'English',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.english',
        locale: LocaleTag.bangla,
        value: 'ইংরেজি',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.boss',
        locale: LocaleTag.english,
        value: 'BCS Trial',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TranslationEntity(
        key: 'lesson.bcs.boss',
        locale: LocaleTag.bangla,
        value: 'বিসিএস ট্রায়াল',
        updatedBy: 'usr_author',
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];

    for (final TranslationEntity e in seed) {
      _entries[_composite(e.key, e.locale)] = e;
      _referencedKeys.add(e.key);
    }
  }

  @override
  Future<List<TranslationEntity>> listByLocale(LocaleTag locale) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _entries.values
        .where((TranslationEntity e) => e.locale == locale)
        .sortedBy<String>((TranslationEntity e) => e.key)
        .toList();
  }

  @override
  Future<TranslationEntity> upsert(TranslationEntity entry) async {
    final String id = _composite(entry.key, entry.locale);
    final TranslationEntity stored = entry.copyWith(updatedAt: DateTime.now());
    _entries[id] = stored;
    _referencedKeys.add(entry.key);
    return stored;
  }

  @override
  Future<void> delete({required String key, required LocaleTag locale}) async {
    _entries.remove(_composite(key, locale));
  }

  @override
  Future<TranslationCoverage> coverage() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final Map<String, int> per = <String, int>{};
    for (final TranslationEntity e in _entries.values) {
      per[e.locale.code] = (per[e.locale.code] ?? 0) + 1;
    }
    return TranslationCoverage(
      total: _referencedKeys.length,
      byLocale: per,
    );
  }

  @override
  Future<List<String>> referencedKeys() async {
    return _referencedKeys.toList()..sort();
  }
}

final translationRepositoryProvider = Provider<TranslationRepository>((Ref ref) {
  return TranslationRepositoryImpl();
});
