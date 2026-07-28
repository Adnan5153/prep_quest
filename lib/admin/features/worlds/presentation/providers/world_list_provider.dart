import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/world_repository_impl.dart';
import '../../domain/entities/world_entity.dart';

final worldListProvider = FutureProvider<List<WorldEntity>>((Ref ref) {
  return ref.watch(worldRepositoryProvider).listWorlds();
});

final worldByIdProvider =
    FutureProvider.family<WorldEntity, String>((Ref ref, String id) {
  return ref.watch(worldRepositoryProvider).getWorld(id);
});

final worldStreamProvider = StreamProvider<List<WorldEntity>>((Ref ref) {
  return ref.watch(worldRepositoryProvider).watchWorlds();
});
