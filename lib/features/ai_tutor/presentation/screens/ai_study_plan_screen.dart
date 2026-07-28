import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../constants/ai_tutor_strings.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_hub_action_card.dart';
import '../widgets/ai_response_section.dart';
import '../widgets/study_plan_day_card.dart';

/// Generates and displays a multi-day study plan.
class AiStudyPlanScreen extends ConsumerStatefulWidget {
  const AiStudyPlanScreen({super.key});

  @override
  ConsumerState<AiStudyPlanScreen> createState() =>
      _AiStudyPlanScreenState();
}

class _AiStudyPlanScreenState extends ConsumerState<AiStudyPlanScreen> {
  final TextEditingController _subject =
      TextEditingController(text: 'English Grammar');
  int _days = 7;
  int _minutes = 45;

  @override
  void dispose() {
    _subject.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AiContentState state =
        ref.watch(aiContentControllerProvider(AiContentKind.studyPlan));

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.studyPlanTitle,
        subtitle: AiTutorStrings.studyPlanFieldSubject,
        onLeadingPressed: () => context.canPop()
            ? context.pop()
            : context.goNamed(AppRoutes.aiTutor),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _subject,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.studyPlanFieldSubject,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _CounterField(
                          label: AiTutorStrings.studyPlanFieldDays,
                          value: _days,
                          min: 3,
                          max: 30,
                          onChanged: (int v) => setState(() => _days = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _CounterField(
                          label: AiTutorStrings.studyPlanFieldMinutes,
                          value: _minutes,
                          min: 15,
                          max: 120,
                          step: 15,
                          onChanged: (int v) => setState(() => _minutes = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.event_note_rounded),
                    label: const Text(AiTutorStrings.studyPlanGenerate),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: switch (state.status) {
                AiTutorLoadStatus.idle ||
                AiTutorLoadStatus.initial =>
                  Center(
                    child: AiTutorEmptyState(
                      title: AiTutorStrings.studyPlanEmptyTitle,
                      subtitle: AiTutorStrings.studyPlanEmptySubtitle,
                      icon: Icons.event_note_rounded,
                    ),
                  ),
                AiTutorLoadStatus.loading =>
                  const AiTutorResponseLoading(
                    message: AiTutorStrings.studyPlanLoading,
                  ),
                AiTutorLoadStatus.error => AiTutorResponseError(
                    message: state.errorMessage,
                    onRetry: _generate,
                  ),
                AiTutorLoadStatus.ready => _PlanList(
                    plan: state.studyPlan!,
                    theme: theme,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final String subject = _subject.text.trim();
    if (subject.isEmpty) return;
    await ref
        .read(aiContentControllerProvider(AiContentKind.studyPlan).notifier)
        .generateStudyPlan(
          subject: subject,
          daysAhead: _days,
          minutesPerDay: _minutes,
        );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList({required this.plan, required this.theme});

  final dynamic plan; // StudyPlan — kept dynamic to avoid a cycle here.
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> days = plan.days as List<dynamic>;
    final int totalMinutes = plan.totalMinutes as int;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.timer_outlined,
                  color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  plan.title as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$totalMinutes min',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (int i = 0; i < days.length; i++)
          StudyPlanDayCard(day: days[i], dayIndex: i),
      ],
    );
  }
}

class _CounterField extends StatelessWidget {
  const _CounterField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$value',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: value <= min ? null : () => onChanged(value - step),
            icon: const Icon(Icons.remove_rounded),
            iconSize: 18,
          ),
          IconButton(
            onPressed: value >= max ? null : () => onChanged(value + step),
            icon: const Icon(Icons.add_rounded),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}