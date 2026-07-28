import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../buildings/library_building.dart';
import '../buildings/playground_building.dart';
import 'shared/playground_sheet_container.dart';
import 'shared/playground_sheet_entrance.dart';
import 'shared/playground_sheet_layout.dart';
import 'shared/playground_sheet_sections.dart';

enum LibraryBottomSheetResult { entered, continueLater, dismissed }

enum LibraryQuickAction { read, flashcards, formulas, aiTutor }

class LibrarySheetVisual {
  const LibrarySheetVisual({
    required this.id,
    required this.title,
    required this.topic,
    required this.description,
    required this.chapterCount,
    required this.completedChapters,
    required this.unlockedLessonCount,
    required this.estimatedReadingMinutes,
    this.isUnlocked = true,
    this.requiredLevel,
    this.level = 1,
  });

  final String id;
  final String title;
  final String topic;
  final String description;
  final int chapterCount;
  final int completedChapters;
  final int unlockedLessonCount;
  final int estimatedReadingMinutes;
  final bool isUnlocked;
  final int? requiredLevel;
  final int level;

  double get completion {
    if (chapterCount <= 0) return 0;
    return (completedChapters / chapterCount).clamp(0.0, 1.0);
  }
}

class LibraryBottomSheet extends StatelessWidget {
  const LibraryBottomSheet({
    super.key,
    required this.visual,
    this.onEnterLibrary,
    this.onContinueLater,
    this.onQuickAction,
  });

  final LibrarySheetVisual visual;
  final VoidCallback? onEnterLibrary;
  final VoidCallback? onContinueLater;
  final ValueChanged<LibraryQuickAction>? onQuickAction;

  static Future<LibraryBottomSheetResult?> show(
    BuildContext context, {
    required LibrarySheetVisual visual,
    VoidCallback? onEnterLibrary,
    VoidCallback? onContinueLater,
    ValueChanged<LibraryQuickAction>? onQuickAction,
  }) {
    final layout = PlaygroundSheetLayout.resolve(context);
    return showModalBottomSheet<LibraryBottomSheetResult>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: PlaygroundSheetOpacity.scrim,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _LibrarySheetHost(
          layout: layout,
          visual: visual,
          onEnterLibrary: onEnterLibrary,
          onContinueLater: onContinueLater,
          onQuickAction: onQuickAction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _LibrarySheetHost(
      layout: PlaygroundSheetLayout.resolve(context),
      visual: visual,
      onEnterLibrary: onEnterLibrary,
      onContinueLater: onContinueLater,
      onQuickAction: onQuickAction,
    );
  }
}

class _LibrarySheetHost extends StatelessWidget {
  const _LibrarySheetHost({
    required this.layout,
    required this.visual,
    required this.onEnterLibrary,
    required this.onContinueLater,
    required this.onQuickAction,
  });

  final PlaygroundSheetLayout layout;
  final LibrarySheetVisual visual;
  final VoidCallback? onEnterLibrary;
  final VoidCallback? onContinueLater;
  final ValueChanged<LibraryQuickAction>? onQuickAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetHeight = layout.maxHeight;
    final container = PlaygroundSheetContainer(
      semanticLabel: PlaygroundStrings.librarySheetSemantic,
      layout: layout,
      height: sheetHeight,
      child: PlaygroundSheetFrame(
        layout: layout,
        semanticLabel: PlaygroundStrings.librarySheetSemantic,
        content: _LibrarySheetBody(
          visual: visual,
          isDark: isDark,
          onQuickAction: onQuickAction,
        ),
        actions: PlaygroundSheetActionRow(
          primaryLabel: PlaygroundStrings.librarySheetCtaEnter,
          onPrimary: () {
            onEnterLibrary?.call();
            Navigator.of(context).pop(LibraryBottomSheetResult.entered);
          },
          primaryIcon: AppIcons.chevronRight,
          primaryEnabled: visual.isUnlocked,
          primarySemantic: PlaygroundStrings.librarySheetCtaEnter,
          secondaryLabel: PlaygroundStrings.librarySheetCtaContinue,
          onSecondary: () {
            onContinueLater?.call();
            Navigator.of(context).pop(LibraryBottomSheetResult.continueLater);
          },
          secondarySemantic: PlaygroundStrings.librarySheetCtaContinue,
          alignment: layout.deviceType == DeviceType.mobile
              ? PlaygroundSheetActionAlignment.stacked
              : PlaygroundSheetActionAlignment.horizontal,
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PlaygroundSheetEntrance(height: sheetHeight, child: container),
    );
  }
}

class _LibrarySheetBody extends StatelessWidget {
  const _LibrarySheetBody({
    required this.visual,
    required this.isDark,
    required this.onQuickAction,
  });

  final LibrarySheetVisual visual;
  final bool isDark;
  final ValueChanged<LibraryQuickAction>? onQuickAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        PlaygroundSheetHeader(
          title: visual.title,
          subtitle: visual.description,
          trailing: visual.isUnlocked
              ? null
              : Semantics(
                  label: PlaygroundStrings.librarySheetLockedSemantic,
                  child: Icon(
                    AppIcons.lockFilled,
                    color: PlaygroundColors.sheetAccentWarning,
                    size: AppSizes.iconMd,
                  ),
                ),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _LibraryHero(visual: visual, isDark: isDark),
        const SizedBox(height: AppSpacing.md),
        PlaygroundSheetProgress(
          value: visual.completion,
          caption: PlaygroundStrings.librarySheetChaptersProgressTemplate
              .replaceAll('%d', '${visual.completedChapters}')
              .replaceFirst('%d', '${visual.chapterCount}'),
          semanticValue: PlaygroundStrings.librarySheetChaptersProgressTemplate
              .replaceAll('%d', '${visual.completedChapters}')
              .replaceFirst('%d', '${visual.chapterCount}'),
          fillColor: PlaygroundColors.sheetAccent,
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.bookmark,
                iconColor: AppColors.libraryPrimary,
                value: '${visual.unlockedLessonCount}',
                label: PlaygroundStrings.librarySheetLessonsLabel,
                semanticValue: PlaygroundStrings.librarySheetLessonsTemplate
                    .replaceAll('%d', '${visual.unlockedLessonCount}'),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.clock,
                iconColor: PlaygroundColors.sheetAccentSecondary,
                value: PlaygroundStrings.librarySheetReadingDurationTemplate
                    .replaceAll('%d', '${visual.estimatedReadingMinutes}'),
                label: PlaygroundStrings.librarySheetReadingDurationLabel,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _LibraryQuickActions(
          enabled: visual.isUnlocked,
          isDark: isDark,
          onQuickAction: onQuickAction,
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _LibraryHero extends StatelessWidget {
  const _LibraryHero({required this.visual, required this.isDark});

  final LibrarySheetVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final state = visual.isUnlocked
        ? BuildingState.unlocked
        : BuildingState.locked;
    return Semantics(
      label: visual.isUnlocked
          ? PlaygroundStrings.buildingSemanticUnlocked
          : PlaygroundStrings.buildingSemanticLocked,
      image: true,
      child: Container(
        height: PlaygroundSizes.bottomSheetHeroHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.libraryPrimary.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              PlaygroundColors.sheetAccentSecondary.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: PlaygroundSheetBorder.heroRadius,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: AppSpacing.lg,
              top: AppSpacing.lg,
              child: ExcludeSemantics(
                child: LibraryBuilding(
                  state: state,
                  title: visual.title,
                  subtitle: visual.topic,
                  progress: visual.completion,
                  level: visual.level,
                  isInteractive: false,
                  showLabel: false,
                  showProgress: false,
                  ambientParticles: !MediaQuery.of(context).disableAnimations,
                  scale: PlaygroundSizes.buildingTabletScale,
                ),
              ),
            ),
            Positioned(
              left: PlaygroundSizes.buildingLibraryWidth + AppSpacing.huge,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    visual.topic,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${visual.completedChapters}/${visual.chapterCount} '
                    '${PlaygroundStrings.librarySheetChaptersLabel}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryQuickActions extends StatelessWidget {
  const _LibraryQuickActions({
    required this.enabled,
    required this.isDark,
    required this.onQuickAction,
  });

  final bool enabled;
  final bool isDark;
  final ValueChanged<LibraryQuickAction>? onQuickAction;

  @override
  Widget build(BuildContext context) {
    const actions = <LibraryQuickAction>[
      LibraryQuickAction.read,
      LibraryQuickAction.flashcards,
      LibraryQuickAction.formulas,
      LibraryQuickAction.aiTutor,
    ];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: actions
          .map((action) {
            return SizedBox(
              width: (MediaQuery.sizeOf(context).width - AppSpacing.huge) / 2,
              child: _LibraryQuickActionTile(
                action: action,
                enabled: enabled,
                isDark: isDark,
                onTap: onQuickAction == null
                    ? null
                    : () => onQuickAction!.call(action),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _LibraryQuickActionTile extends StatelessWidget {
  const _LibraryQuickActionTile({
    required this.action,
    required this.enabled,
    required this.isDark,
    required this.onTap,
  });

  final LibraryQuickAction action;
  final bool enabled;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (action) {
      LibraryQuickAction.read => AppIcons.bookmark,
      LibraryQuickAction.flashcards => AppIcons.note,
      LibraryQuickAction.formulas => AppIcons.info,
      LibraryQuickAction.aiTutor => AppIcons.sparkle,
    };
    final label = switch (action) {
      LibraryQuickAction.read => PlaygroundStrings.librarySheetQuickRead,
      LibraryQuickAction.flashcards =>
        PlaygroundStrings.librarySheetQuickFlashcards,
      LibraryQuickAction.formulas =>
        PlaygroundStrings.librarySheetQuickFormulas,
      LibraryQuickAction.aiTutor => PlaygroundStrings.librarySheetQuickAiTutor,
    };
    return Semantics(
      button: true,
      enabled: enabled && onTap != null,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: PlaygroundSheetBorder.quickRadius,
          child: Container(
            height: PlaygroundSizes.bottomSheetQuickActionHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkMuted : AppColors.lightMuted)
                  .withValues(alpha: PlaygroundSheetOpacity.accentSurface),
              borderRadius: PlaygroundSheetBorder.quickRadius,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: enabled
                      ? PlaygroundColors.sheetAccent
                      : PlaygroundColors.sheetHandleLight,
                  size: PlaygroundSizes.bottomSheetQuickActionIconSize,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
