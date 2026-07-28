import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../constants/quiz_results_strings.dart';
import '../providers/quiz_results_provider.dart';

class PerformanceBreakdownScreen extends ConsumerWidget {
  const PerformanceBreakdownScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizResultsControllerProvider(quizId));
    final result = state.performance?.result;
    final entries = result?.questionResults.entries.toList() ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(QuizResultsStrings.performanceBreakdownTitle)),
      body: SafeArea(
        child: entries.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemBuilder: (_, i) {
                  final entry = entries[i];
                  return ListTile(
                    leading: Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      color: entry.value ? Colors.green : Colors.red,
                    ),
                    title: Text(entry.key),
                    trailing: Text(entry.value ? '✓' : '✗'),
                  );
                },
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: entries.length,
              ),
      ),
    );
  }
}
