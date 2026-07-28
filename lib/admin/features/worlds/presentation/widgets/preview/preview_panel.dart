import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../../../shared/enums/workflow_state.dart';
import '../../../../themes/presentation/providers/themes_provider.dart';
import '../../../../translations/presentation/providers/translations_provider.dart';
import '../../../domain/entities/building_entity.dart';
import '../../../domain/entities/decoration_entity.dart';
import '../../../domain/entities/node_entity.dart';
import '../../../domain/entities/path_entity.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class PreviewPanel extends ConsumerWidget {
  const PreviewPanel({
    required this.controller,
    required this.draft,
    super.key,
  });

  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorldEditorState s = controller.value;
    final ThemeData theme = Theme.of(context);
    final themes = ref.watch(themesListProvider);
    return Container(
      constraints: const BoxConstraints(maxHeight: AdminSpacing.timelineHeight),
      decoration: BoxDecoration(
        color: AdminPalette.canvasPaperDark,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AdminSpacing.md, vertical: AdminSpacing.xs),
            child: Row(
              children: <Widget>[
                const Icon(Icons.preview_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: AdminSpacing.sm),
                Text('Live preview',
                    style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
                const Spacer(),
                DropdownButton<String?>(
                  dropdownColor: AdminPalette.graphite,
                  value: s.previewThemeId,
                  hint: Text('Default theme',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                  items: <DropdownMenuItem<String?>>[
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Default theme')),
                    ...themes.maybeWhen(
                      data: (List<ThemeSummary> list) => list
                          .map((ThemeSummary t) => DropdownMenuItem<String?>(
                                value: t.id,
                                child: Text(t.displayName),
                              )),
                      orElse: () => const <DropdownMenuItem<String?>>[],
                    ),
                  ],
                  onChanged: (String? v) {
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .setPreviewTheme(v);
                    controller.value = ref.read(worldEditorControllerProvider(draft));
                  },
                ),
                const SizedBox(width: AdminSpacing.sm),
                DropdownButton<LocaleTag>(
                  dropdownColor: AdminPalette.graphite,
                  value: s.previewLocale,
                  items: LocaleTag.values
                      .map((LocaleTag l) => DropdownMenuItem<LocaleTag>(
                            value: l,
                            child: Text(l.code.toUpperCase(),
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (LocaleTag? v) {
                    if (v == null) return;
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .setPreviewLocale(v);
                    controller.value = ref.read(worldEditorControllerProvider(draft));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: PreviewPainter(
                draft: draft,
                themeId: s.previewThemeId,
                locale: s.previewLocale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewPainter extends ConsumerWidget {
  const PreviewPainter({
    required this.draft,
    required this.themeId,
    required this.locale,
    super.key,
  });

  final WorldDraftEntity draft;
  final String? themeId;
  final LocaleTag locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themesListProvider);
    final translations = ref.watch(translationsListProvider(locale));
    final Color ground = themes.maybeWhen(
      data: (List<ThemeSummary> list) {
        final ThemeSummary? selected = list
            .where((ThemeSummary t) => t.id == themeId)
            .firstOrNull;
        if (selected == null) return const Color(0xFF7CB342);
        if (selected.id == 'thm_winter') return const Color(0xFFCED5DA);
        if (selected.id == 'thm_monsoon') return const Color(0xFF3F7E47);
        if (selected.id == 'thm_night') return const Color(0xFF263238);
        if (selected.id == 'thm_eid') return const Color(0xFF66BB6A);
        return const Color(0xFF7CB342);
      },
      orElse: () => const Color(0xFF7CB342),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        return CustomPaint(
          painter: _PreviewPainterImpl(
            draft: draft,
            ground: ground,
            locale: locale,
            translationFor: (String key) {
              return translations.maybeWhen(
                data: (List<TranslationEntry> list) {
                  final TranslationEntry? match = list
                      .where((TranslationEntry e) => e.key == key)
                      .firstOrNull;
                  return match?.value ?? key;
                },
                orElse: () => key,
              );
            },
          ),
        );
      },
    );
  }
}

class _PreviewPainterImpl extends CustomPainter {
  _PreviewPainterImpl({
    required this.draft,
    required this.ground,
    required this.locale,
    required this.translationFor,
  });

  final WorldDraftEntity draft;
  final Color ground;
  final LocaleTag locale;
  final String Function(String key) translationFor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFA6D8FF), Color(0xFFE4F4FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, skyPaint);
    final Paint groundPaint = Paint()..color = ground;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25),
      groundPaint,
    );

    final double scale = size.width / 800;
    canvas.save();
    canvas.scale(scale);
    canvas.translate(40, 40);

    for (final WorldPathEntity p in draft.paths) {
      final Paint stroke = Paint()
        ..color = const Color(0xFFC9A36B)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (final PathSegmentEntity s in p.segments) {
        if (s.kind == PathSegmentKind.bezier && s.control != null) {
          final Path path = Path()
            ..moveTo(s.start.x, s.start.y)
            ..quadraticBezierTo(
              s.control!.x,
              s.control!.y,
              s.end.x,
              s.end.y,
            );
          canvas.drawPath(path, stroke);
        }
      }
    }

    for (final BuildingEntity b in draft.buildings) {
      final Rect rect = Rect.fromLTWH(
        b.coordinate.x - b.width / 2,
        b.coordinate.y - b.height / 2,
        b.width,
        b.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()..color = const Color(0xFFE8D5B7),
      );
    }

    for (final DecorationEntity d in draft.decorations) {
      canvas.drawCircle(
        Offset(d.coordinate.x, d.coordinate.y),
        14 * d.scale,
        Paint()..color = const Color(0xFF2E7D32),
      );
    }

    for (final NodeEntity n in draft.nodes) {
      Color color = const Color(0xFF0E7C4A);
      if (n.kind == WorldObjectKind.bossGate) color = const Color(0xFFF5A623);
      final double radius = n.kind == WorldObjectKind.bossGate ? 26 : 18;
      canvas.drawCircle(
        Offset(n.coordinate.x, n.coordinate.y),
        radius,
        Paint()..color = color,
      );
      if (n.levelNumber != null) {
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: '${n.levelNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            n.coordinate.x - tp.width / 2,
            n.coordinate.y - tp.height / 2,
          ),
        );
      }
    }

    for (final NodeEntity n in draft.nodes) {
      if (n.titleKey == null) continue;
      final String title = translationFor(n.titleKey!);
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 220);
      tp.paint(
        canvas,
        Offset(n.coordinate.x - tp.width / 2, n.coordinate.y + 24),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PreviewPainterImpl old) =>
      old.draft != draft ||
      old.ground != ground ||
      old.locale != locale;
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
