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
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';
import '../widgets/note_editor.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  const EditNoteScreen({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  NoteEntity? _note;
  NoteCategory _category = NoteCategory.personal;
  NoteColor _color = NoteColor.defaultColor;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _tagsController = TextEditingController();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final NoteEntity? loaded =
        await ref.read(notesControllerProvider.notifier).findById(widget.noteId);
    if (!mounted) return;
    if (loaded == null) {
      setState(() => _loading = false);
      return;
    }
    _titleController.text = loaded.title;
    _contentController.text = loaded.content;
    _tagsController.text = loaded.tags.join(', ');
    setState(() {
      _note = loaded;
      _category = loaded.category;
      _color = loaded.color;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final NoteEntity? current = _note;
    if (current == null) return;
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.notesValidationTitleRequired)),
      );
      return;
    }
    final NoteEntity updated = current.copyWith(
      title: title,
      content: content,
      category: _category,
      color: _color,
      tags: _parseTags(_tagsController.text),
    );
    final NoteEntity? saved = await ref
        .read(notesControllerProvider.notifier)
        .update(updated);
    if (!mounted) return;
    if (saved != null) context.pop();
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

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toSet()
        .toList(growable: false);
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
        title: const Text(AppStrings.notesEditTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.pop(),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.notesDeleteCta,
            icon: const Icon(AppIcons.noteDelete),
            onPressed: _delete,
          ),
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(AppIcons.noteAdd),
            label: const Text(AppStrings.notesSaveCta),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _note == null
              ? const Center(child: Text(AppStrings.notesError))
              : Center(
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
                      onColorChanged: (NoteColor c) =>
                          setState(() => _color = c),
                    ),
                  ),
                ),
    );
  }
}
