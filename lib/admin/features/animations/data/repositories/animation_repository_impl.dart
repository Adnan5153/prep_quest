import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/animation_entity.dart';
import '../../domain/repositories/animation_repository.dart';

class AnimationRepositoryImpl implements AnimationRepository {
  AnimationRepositoryImpl() {
    _seed();
  }

  final Map<String, AnimationEntity> _animations = <String, AnimationEntity>{};

  void _seed() {
    final DateTime now = DateTime.now();
    final AnimationEntity nodeGlow = AnimationEntity(
      id: 'anm_node_glow',
      slug: 'node-glow',
      displayName: 'Node Glow Pulse',
      durationMs: 1600,
      tracks: <AnimationTrack>[
        AnimationTrack(
          property: AnimationProperty.opacity,
          keyframes: <AnimationKeyframe>[
            AnimationKeyframe(
              timeMs: 0,
              value: 0.6,
              easing: AnimationEasing.easeIn,
            ),
            AnimationKeyframe(
              timeMs: 800,
              value: 1,
              easing: AnimationEasing.easeOut,
            ),
            AnimationKeyframe(
              timeMs: 1600,
              value: 0.6,
              easing: AnimationEasing.easeIn,
            ),
          ],
        ),
        AnimationTrack(
          property: AnimationProperty.scale,
          keyframes: <AnimationKeyframe>[
            AnimationKeyframe(
              timeMs: 0,
              value: 1,
              easing: AnimationEasing.easeIn,
            ),
            AnimationKeyframe(
              timeMs: 800,
              value: 1.08,
              easing: AnimationEasing.easeOut,
            ),
            AnimationKeyframe(
              timeMs: 1600,
              value: 1,
              easing: AnimationEasing.easeIn,
            ),
          ],
        ),
      ],
      looping: AnimationLoopMode.loop,
      events: <AnimationEvent>[
        AnimationEvent(timeMs: 800, name: 'glow-peak'),
      ],
      updatedAt: now.subtract(const Duration(days: 10)),
    );

    final AnimationEntity chest = AnimationEntity(
      id: 'anm_chest',
      slug: 'chest-unlock',
      displayName: 'Chest Unlock',
      durationMs: 1500,
      tracks: <AnimationTrack>[
        AnimationTrack(
          property: AnimationProperty.scale,
          keyframes: <AnimationKeyframe>[
            AnimationKeyframe(timeMs: 0, value: 1, easing: AnimationEasing.easeInOut),
            AnimationKeyframe(timeMs: 700, value: 1.15, easing: AnimationEasing.easeOut),
            AnimationKeyframe(timeMs: 1500, value: 1, easing: AnimationEasing.easeInOut),
          ],
        ),
        AnimationTrack(
          property: AnimationProperty.rotate,
          keyframes: <AnimationKeyframe>[
            AnimationKeyframe(timeMs: 0, value: 0, easing: AnimationEasing.linear),
            AnimationKeyframe(timeMs: 1500, value: 0.05, easing: AnimationEasing.easeInOut),
          ],
        ),
      ],
      looping: AnimationLoopMode.none,
      events: const <AnimationEvent>[],
      updatedAt: now.subtract(const Duration(days: 5)),
    );

    final AnimationEntity pathReveal = AnimationEntity(
      id: 'anm_path_reveal',
      slug: 'path-reveal',
      displayName: 'Path Reveal',
      durationMs: 800,
      tracks: <AnimationTrack>[
        AnimationTrack(
          property: AnimationProperty.opacity,
          keyframes: <AnimationKeyframe>[
            AnimationKeyframe(timeMs: 0, value: 0, easing: AnimationEasing.easeOut),
            AnimationKeyframe(timeMs: 800, value: 1, easing: AnimationEasing.easeOut),
          ],
        ),
      ],
      looping: AnimationLoopMode.none,
      events: const <AnimationEvent>[],
      updatedAt: now.subtract(const Duration(days: 5)),
    );

    _animations[nodeGlow.id] = nodeGlow;
    _animations[chest.id] = chest;
    _animations[pathReveal.id] = pathReveal;
  }

  @override
  Future<List<AnimationEntity>> listAnimations() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _animations.values.toList();
  }

  @override
  Future<AnimationEntity> upsertAnimation(AnimationEntity animation) async {
    final String id =
        animation.id.isEmpty ? 'anm_${Ulid.generate()}' : animation.id;
    final AnimationEntity stored =
        animation.copyWith(id: id, updatedAt: DateTime.now());
    _animations[id] = stored;
    return stored;
  }

  @override
  Future<void> deleteAnimation(String id) async {
    _animations.remove(id);
  }
}

final animationRepositoryProvider = Provider<AnimationRepository>((Ref ref) {
  return AnimationRepositoryImpl();
});
