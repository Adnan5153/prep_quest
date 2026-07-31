import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/domain/entities/coin_transaction.dart';

/// Recent-activity list on the home dashboard. Renders the most
/// recent [limit] coin-ledger entries so the user can see what they
/// earned or spent since they last opened the app.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({
    super.key,
    required this.entries,
    this.limit = 5,
  });

  final List<CoinTransactionEntity> entries;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final List<CoinTransactionEntity> recent = entries.take(limit).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkMuted.withValues(alpha: 0.4)
              : AppColors.lightMuted.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.homeRecentActivityTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            Text(
              AppStrings.homeRecentActivityEmpty,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            )
          else
            ...recent.map((entry) => _RecentActivityRow(entry: entry, isDark: isDark)),
        ],
      ),
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({required this.entry, required this.isDark});

  final CoinTransactionEntity entry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCredit = entry.type == CoinTransactionType.earn ||
        entry.type == CoinTransactionType.bonus ||
        entry.type == CoinTransactionType.reward ||
        entry.type == CoinTransactionType.restore;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Icon(
            isCredit ? Icons.add_circle : Icons.remove_circle,
            size: 20,
            color: isCredit ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.reason ?? entry.source.name,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}${entry.amount}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isCredit ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}