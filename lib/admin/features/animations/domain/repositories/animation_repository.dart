import '../entities/animation_entity.dart';

abstract class AnimationRepository {
  Future<List<AnimationEntity>> listAnimations();
  Future<AnimationEntity> upsertAnimation(AnimationEntity animation);
  Future<void> deleteAnimation(String id);
}
