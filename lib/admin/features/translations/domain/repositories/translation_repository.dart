import '../../../../shared/enums/workflow_state.dart';
import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<List<TranslationEntity>> listByLocale(LocaleTag locale);
  Future<TranslationEntity> upsert(TranslationEntity entry);
  Future<void> delete({required String key, required LocaleTag locale});
  Future<TranslationCoverage> coverage();
  Future<List<String>> referencedKeys();
}
