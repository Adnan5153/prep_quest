import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/coin_transaction.dart';
import '../providers/coin_providers.dart';

/// Read-only ledger viewer.
///
/// Reads `coinHistoryProvider` and surfaces the most recent 50
/// transactions. The screen is intentionally minimalist — the data
/// shape is finalised in Phase 41, but the rich empty / error / day
/// grouping UX is a follow-up ticket that lands after the offline
/// sync + audit flows are exercised end-to-end.
class CoinHistoryScreen extends ConsumerWidget {
  const CoinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CoinTransactionEntity>> history =
        ref.watch(coinHistoryProvider);
    final int balance = ref.watch(coinBalanceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin history'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Current balance: $balance coins',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: history.when(
              data: (List<CoinTransactionEntity> entries) {
                if (entries.isEmpty) {
                  return const Center(
                    child: Text('No coin activity yet.'),
                  );
                }
                return ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final CoinTransactionEntity entry = entries[index];
                    return ListTile(
                      leading: _SignIndicator(amount: entry.signedDelta),
                      title: Text(entry.reason ?? entry.source.id),
                      subtitle: Text(
                        '${entry.source.id} · ${entry.createdAt.toLocal()}',
                      ),
                      trailing: Text(
                        '${entry.signedDelta > 0 ? '+' : ''}${entry.amount}',
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (Object error, _) => Center(
                child: Text('Failed to load history: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignIndicator extends StatelessWidget {
  const _SignIndicator({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final bool credit = amount >= 0;
    return CircleAvatar(
      backgroundColor: credit
          ? Colors.green.shade100
          : Colors.red.shade100,
      child: Icon(
        credit ? Icons.add : Icons.remove,
        color: credit ? Colors.green.shade800 : Colors.red.shade800,
      ),
    );
  }
}
