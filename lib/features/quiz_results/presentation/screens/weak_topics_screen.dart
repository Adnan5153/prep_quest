import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../constants/quiz_results_strings.dart';
import '../providers/quiz_results_provider.dart';
import '../widgets/result_topics/topic_breakdown_tile.dart';

class WeakTopicsScreen extends ConsumerWidget {
  const WeakTopicsScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizResultsControllerProvider(quizId));
    final performance = state.performance;
    final weak = performance?.topicBreakdown
            .where((t) => t.isWeak)
            .toList(growable: false) ??
        const [];

    return Scaffold(
      appBar: AppBar(title: Text(QuizResultsStrings.weakTopicsScreenTitle)),
      body: SafeArea(
        child: weak.isEmpty
            ? const Center(
                child: Text(QuizResultsStrings.loadingResults),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemBuilder: (_, i) => TopicBreakdownTile(topic: weak[i]),
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: weak.length,
              ),
      ),
    );
  }
}
