import '../../domain/entities/reward.dart';
import '../../domain/entities/reward_history_entry.dart';

class RewardHistoryEntryModel {
  const RewardHistoryEntryModel({
    required this.id,
    required this.grantedAtIso,
    required this.sourceLabel,
    required this.grantDump,
    this.contextKey,
  });

  final String id;
  final String grantedAtIso;
  final String sourceLabel;
  final String? contextKey;

  /// Compact dump of every grant this entry produced. Restored by
  /// the repository implementation when the entry is loaded.
  final List<Reward> grantDump;

  RewardHistoryEntry toEntity() {
    return RewardHistoryEntry(
      id: id,
      grantedAtIso: grantedAtIso,
      sourceLabel: sourceLabel,
      contextKey: contextKey,
      grants: List<Reward>.unmodifiable(grantDump),
    );
  }
}