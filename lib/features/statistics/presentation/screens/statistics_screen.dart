import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../router.dart';
import '../../domain/enums/statistics_enums.dart';
import '../providers/statistics_provider.dart';
import '../utils/statistics_visual_mapper.dart';
import '../widgets/accuracy_statistics/accuracy_statistics_section.dart';
import '../widgets/charts/charts_section.dart';
import '../widgets/shared/statistics_state_views.dart';
import '../widgets/statistics_header/statistics_header.dart';
import '../widgets/strong_subjects/strong_subjects_section.dart';
import '../widgets/study_time/study_time_section.dart';
import '../widgets/weak_subjects/weak_subjects_section.dart';
import '../widgets/xp_statistics/xp_statistics_section.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(statisticsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StatisticsState state = ref.watch(statisticsControllerProvider);
    final StatisticsVisual? visual = state.visual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileBody(state, visual),
          tablet: _buildWideBody(state, visual),
          desktop: _buildWideBody(state, visual),
          largeDesktop: _buildWideBody(state, visual),
        ),
      ),
    );
  }

  Widget _buildMobileBody(StatisticsState state, StatisticsVisual? visual) {
    return _BodyContent(state: state, visual: visual);
  }

  Widget _buildWideBody(StatisticsState state, StatisticsVisual? visual) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: _BodyContent(state: state, visual: visual),
      ),
    );
  }
}

class _BodyContent extends ConsumerWidget {
  const _BodyContent({required this.state, required this.visual});

  final StatisticsState state;
  final StatisticsVisual? visual;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == StatisticsLoadStatus.initial ||
        (state.status == StatisticsLoadStatus.loading && visual == null)) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: const <Widget>[
          StatisticsHeaderSkeleton(),
          SizedBox(height: AppSpacing.lg),
          StatisticsLoadingView(),
        ],
      );
    }

    if (state.status == StatisticsLoadStatus.error && visual == null) {
      return StatisticsErrorView(
        message: state.errorMessage ?? 'Could not load statistics',
        onRetry: () =>
            ref.read(statisticsControllerProvider.notifier).load(forceRefresh: true),
      );
    }

    if (visual == null || state.isEmpty) {
      return const StatisticsEmptyView();
    }
    final StatisticsVisual ready = visual!;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(statisticsControllerProvider.notifier).load(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          const StatisticsHeader(),
          const SizedBox(height: AppSpacing.lg),
          XpStatisticsSection(visual: ready),
          const SizedBox(height: AppSpacing.lg),
          AccuracyStatisticsSection(visual: ready),
          const SizedBox(height: AppSpacing.lg),
          StudyTimeSection(visual: ready),
          const SizedBox(height: AppSpacing.lg),
          WeakSubjectsSection(visual: ready),
          const SizedBox(height: AppSpacing.lg),
          StrongSubjectsSection(visual: ready),
          const SizedBox(height: AppSpacing.lg),
          ChartsSection(visual: ready),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}