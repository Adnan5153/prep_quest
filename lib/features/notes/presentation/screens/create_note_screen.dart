import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';
import '../../domain/enums/note_type.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_editor.dart';

class CreateNoteScreen extends ConsumerStatefulWidget {
  const CreateNoteScreen({super.key, this.initial});

  final NoteEntity? initial;

  @override
  ConsumerState<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends ConsumerState<CreateNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  NoteCategory _category = NoteCategory.personal;
  NoteColor _color = NoteColor.defaultColor;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initial?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initial?.content ?? '');
    _tagsController = TextEditingController(
      text: (widget.initial?.tags ?? const <String>[]).join(', '),
    );
    _category = widget.initial?.category ?? NoteCategory.personal;
    _color = widget.initial?.color ?? NoteColor.defaultColor;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty) {
      _showError(AppStrings.notesValidationTitleRequired);
      return;
    }
    if (content.isEmpty) {
      _showError(AppStrings.notesValidationContentRequired);
      return;
    }
    if (title.length > 120) {
      _showError(AppStrings.notesValidationTitleTooLong);
      return;
    }
    if (content.length > 10000) {
      _showError(AppStrings.notesValidationContentTooLong);
      return;
    }

    final DateTime now = DateTime.now();
    final NoteEntity draft = NoteEntity(
      id: 'note-${now.millisecondsSinceEpoch}',
      title: title,
      content: content,
      type: NoteType.personal,
      category: _category,
      color: _color,
      isPinned: false,
      isFavorite: false,
      tags: _parseTags(_tagsController.text),
      attachments: const <NoteAttachmentEntity>[],
      createdAtIso: now.toIso8601String(),
      updatedAtIso: now.toIso8601String(),
    );

    final NoteEntity? saved = await ref
        .read(notesControllerProvider.notifier)
        .create(draft);
    if (!mounted) return;
    if (saved == null) {
      _showError(AppStrings.notesError);
      return;
    }
    context.pop();
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        title: const Text(AppStrings.notesCreateTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.pop(),
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(AppIcons.noteAdd),
            label: const Text(AppStrings.notesSaveCta),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: NoteEditor(
            titleController: _titleController,
            contentController: _contentController,
            tagsController: _tagsController,
            category: _category,
            color: _color,
            onCategoryChanged: (NoteCategory c) =>
                setState(() => _category = c),
            onColorChanged: (NoteColor c) => setState(() => _color = c),
          ),
        ),
      ),
    );
  }
}
