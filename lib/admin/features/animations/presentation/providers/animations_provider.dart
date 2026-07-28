import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/animation_repository_impl.dart';
import '../../domain/entities/animation_entity.dart';

class AnimationSummary {
  const AnimationSummary({
    required this.id,
    required this.displayName,
    required this.durationMs,
  });

  final String id;
  final String displayName;
  final int durationMs;
}

final animationsListProvider = FutureProvider<List<AnimationSummary>>(
    (Ref ref) async {
  final List<AnimationEntity> list =
      await ref.watch(animationRepositoryProvider).listAnimations();
  return list
      .map((AnimationEntity a) => AnimationSummary(
            id: a.id,
            displayName: a.displayName,
            durationMs: a.durationMs,
          ))
      .toList();
});
