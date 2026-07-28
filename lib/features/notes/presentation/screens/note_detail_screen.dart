import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_type.dart';
import '../extensions/note_color_extension.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';
import '../widgets/note_share_sheet.dart';
import '../widgets/note_tag_chip.dart';
import '../widgets/note_toolbar.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  const NoteDetailScreen({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  NoteEntity? _note;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final NoteEntity? loaded = await ref
        .read(notesControllerProvider.notifier)
        .findById(widget.noteId);
    if (!mounted) return;
    setState(() {
      _note = loaded;
      _loading = false;
    });
  }

  Future<void> _edit() async {
    await context.pushNamed(
      AppRoutes.noteEdit,
      queryParameters: <String, String>{'id': widget.noteId},
    );
    if (!mounted) return;
    await _hydrate();
  }

  Future<void> _delete() async {
    final NoteEntity? current = _note;
    if (current == null) return;
    final bool confirm = await DeleteNoteDialog.show(context);
    if (!confirm) return;
    await ref.read(notesControllerProvider.notifier).remove(current.id);
    if (!mounted) return;
    context.pop();
  }

  void _share() {
    final NoteEntity? current = _note;
    if (current == null) return;
    NoteShareSheet.show(context, current);
  }

  Future<void> _togglePin() async {
    final NoteEntity? current = _note;
    if (current == null) return;
    await ref.read(notesControllerProvider.notifier).togglePinFor(current.id);
    await _hydrate();
  }

  Future<void> _toggleFavorite() async {
    final NoteEntity? current = _note;
    if (current == null) return;
    await ref
        .read(notesControllerProvider.notifier)
        .toggleFavoriteFor(current.id);
    await _hydrate();
  }

  String _typeLabel() {
    final NoteEntity? current = _note;
    switch (current?.type ?? NoteType.personal) {
      case NoteType.personal:
        return AppStrings.notesTypePersonal;
      case NoteType.highlight:
        return AppStrings.notesTypeHighlight;
      case NoteType.ai:
        return AppStrings.notesTypeAi;
    }
  }

  IconData _typeIcon() {
    final NoteEntity? current = _note;
    switch (current?.type ?? NoteType.personal) {
      case NoteType.personal:
        return AppIcons.noteContent;
      case NoteType.highlight:
        return AppIcons.noteHighlight;
      case NoteType.ai:
        return AppIcons.noteAiFilled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720,
      desktop: 960,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.noteBack),
          onPressed: () => context.goNamed(AppRoutes.notes),
        ),
        title: const Text(AppStrings.notesDetailTitle),
        actions: <Widget>[
          if (_note != null)
            NoteToolbar(
              note: _note!,
              onTogglePin: _togglePin,
              onToggleFavorite: _toggleFavorite,
              onShare: _share,
              onEdit: _edit,
              onDelete: _delete,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _note == null
              ? const Center(child: Text(AppStrings.notesError))
              : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: _DetailBody(
                        note: _note!,
                        typeLabel: _typeLabel(),
                        typeIcon: _typeIcon(),
                      ),
                    ),
                  ),
                ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.note,
    required this.typeLabel,
    required this.typeIcon,
  });

  final NoteEntity note;
  final String typeLabel;
  final IconData typeIcon;

  String _formatDate(String iso) {
    final DateTime? parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: note.color.resolve(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: note.color.resolveAccent(context).withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(typeIcon, color: note.color.resolveAccent(context)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                typeLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: note.color.resolveAccent(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              CategoryChip(
                label: note.category.displayLabel,
                selected: false,
                enabled: false,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            note.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            note.content,
            style: theme.textTheme.bodyLarge,
          ),
          if (note.tags.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.notesTagsLabel, style: theme.textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final String t in note.tags) NoteTagChip(label: t),
              ],
            ),
          ],
          if (note.attachments.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.notesAttachmentsLabel,
                style: theme.textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            for (final dynamic a in note.attachments)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(AppIcons.noteAttachment),
                title: Text(a.title as String),
                subtitle: Text((a.subtitle as String?) ?? ''),
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Icon(AppIcons.noteClock,
                  size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${AppStrings.notesUpdatedLabel}: ${_formatDate(note.updatedAtIso)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
