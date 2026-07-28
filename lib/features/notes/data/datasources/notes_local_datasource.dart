import 'dart:async';

import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';
import '../../domain/enums/note_type.dart';
import '../models/note_model.dart';

/// In-memory store mirroring every other feature's local datasource.
///
/// Holds all notes in memory and filters/sorts synchronously.
class NotesLocalDataSource {
  NotesLocalDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  List<NoteModel>? _cache;

  final StreamController<List<NoteModel>> _changes =
      StreamController<List<NoteModel>>.broadcast();

  Stream<List<NoteModel>> watch() => _changes.stream;

  List<NoteModel> readAll() {
    _ensureCache();
    return List<NoteModel>.unmodifiable(_cache!);
  }

  void writeAll(List<NoteModel> rows) {
    _cache = List<NoteModel>.unmodifiable(rows);
    _changes.add(readAll());
  }

  void writeOne(NoteModel row) {
    _ensureCache();
    final List<NoteModel> next = List<NoteModel>.from(_cache!);
    final int idx = next.indexWhere((NoteModel r) => r.id == row.id);
    if (idx >= 0) {
      next[idx] = row;
    } else {
      next.insert(0, row);
    }
    _cache = List<NoteModel>.unmodifiable(next);
    _changes.add(readAll());
  }

  bool removeOne(String id) {
    _ensureCache();
    final List<NoteModel> next =
        _cache!.where((NoteModel r) => r.id != id).toList(growable: false);
    if (next.length == _cache!.length) return false;
    _cache = List<NoteModel>.unmodifiable(next);
    _changes.add(readAll());
    return true;
  }

  void clear() {
    _cache = const <NoteModel>[];
    _changes.add(readAll());
  }

  void dispose() {
    _changes.close();
  }

  void _ensureCache() {
    _cache ??= List<NoteModel>.unmodifiable(_seedNotes());
  }

  List<NoteModel> _seedNotes() {
    final DateTime now = _clock();
    DateTime ago(int days, [int hours = 0]) =>
        now.subtract(Duration(days: days, hours: hours));

    return <NoteModel>[
      NoteModel(
        id: 'note-constitution-articles',
        title: 'Constitution: Articles to remember',
        content:
            'Part V covers the union executive; Articles 52–73 cover Parliament. '
            'Article 70 is the anti-defection law — keep this handy for MCQs.',
        type: NoteType.personal,
        category: NoteCategory.study,
        color: NoteColor.yellow,
        isPinned: true,
        isFavorite: true,
        tags: const <String>['constitution', 'bcs', 'prelims'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(1, 2).toIso8601String(),
        updatedAtIso: ago(0, 6).toIso8601String(),
        sourceFeature: 'notes',
      ),
      NoteModel(
        id: 'note-math-shortcuts',
        title: 'Percentage shortcuts — quick reference',
        content:
            'x% of y = (x * y) / 100. Successive %: a% of b% of N = '
            'N * (a + b − (a*b)/100) / 100.',
        type: NoteType.personal,
        category: NoteCategory.study,
        color: NoteColor.green,
        isPinned: true,
        isFavorite: false,
        tags: const <String>['math', 'shortcuts', 'bank'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(3).toIso8601String(),
        updatedAtIso: ago(1).toIso8601String(),
        sourceFeature: 'notes',
      ),
      NoteModel(
        id: 'note-highlight-liberation-war',
        title: 'Highlight — Liberation War timeline',
        content:
            '"The declaration of independence was broadcast from Kalurghat on '
            'March 26, 1971, before the formal crackdown began in Dhaka."',
        type: NoteType.highlight,
        category: NoteCategory.insight,
        color: NoteColor.blue,
        isPinned: false,
        isFavorite: true,
        tags: const <String>['1971', 'history'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(5, 4).toIso8601String(),
        updatedAtIso: ago(5, 4).toIso8601String(),
        sourceFeature: 'guidebook',
      ),
      NoteModel(
        id: 'note-ai-demand-elasticity',
        title: 'AI: Elasticity of demand',
        content:
            'Elasticity measures responsiveness of quantity demanded to a '
            'change in price. Ed = (%ΔQd) / (%ΔP). When |Ed| > 1 demand is '
            'elastic; |Ed| < 1 inelastic; |Ed| = 1 unit elastic. Total '
            'revenue is maximised at unit elasticity.',
        type: NoteType.ai,
        category: NoteCategory.ai,
        color: NoteColor.purple,
        isPinned: false,
        isFavorite: false,
        tags: const <String>['economics', 'ai', 'concept'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(2, 3).toIso8601String(),
        updatedAtIso: ago(2, 3).toIso8601String(),
        sourceFeature: 'ai_tutor',
      ),
      NoteModel(
        id: 'note-english-tense-rules',
        title: 'English — Past perfect vs past simple',
        content:
            'Past perfect: action completed before another past point '
            '(had + V3). Past simple: completed action at a definite past '
            'time (V2).',
        type: NoteType.personal,
        category: NoteCategory.review,
        color: NoteColor.pink,
        isPinned: false,
        isFavorite: false,
        tags: const <String>['english', 'grammar'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(7).toIso8601String(),
        updatedAtIso: ago(4).toIso8601String(),
        sourceFeature: 'notes',
      ),
      NoteModel(
        id: 'note-question-bcs-2024',
        title: 'BCS 2024 — tough MCQs to revisit',
        content:
            'Revisit the geography set on rivers; confused between Padma and '
            'Meghna tributaries. Also need to revisit finance commission '
            'composition (Art. 280).',
        type: NoteType.personal,
        category: NoteCategory.question,
        color: NoteColor.defaultColor,
        isPinned: false,
        isFavorite: true,
        tags: const <String>['bcs', '2024', 'mcq'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(10).toIso8601String(),
        updatedAtIso: ago(6).toIso8601String(),
        sourceFeature: 'notes',
      ),
      NoteModel(
        id: 'note-ai-question-bank-strategy',
        title: 'AI: Question-bank strategy',
        content:
            'Use spaced repetition: revisit missed questions after 1 day, '
            '3 days, 7 days. Mark high-yield topics and rotate them into '
            'mock tests weekly.',
        type: NoteType.ai,
        category: NoteCategory.ai,
        color: NoteColor.defaultColor,
        isPinned: false,
        isFavorite: false,
        tags: const <String>['strategy', 'ai'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(4, 6).toIso8601String(),
        updatedAtIso: ago(4, 6).toIso8601String(),
        sourceFeature: 'ai_tutor',
      ),
      NoteModel(
        id: 'note-highlight-macroeconomics',
        title: 'Highlight — Monetary policy tools',
        content:
            '"Open market operations, the discount rate, and reserve '
            'requirements are the three traditional tools of monetary '
            'policy."',
        type: NoteType.highlight,
        category: NoteCategory.insight,
        color: NoteColor.blue,
        isPinned: false,
        isFavorite: false,
        tags: const <String>['economics', 'macro'],
        attachments: const <NoteAttachmentEntity>[],
        createdAtIso: ago(8).toIso8601String(),
        updatedAtIso: ago(8).toIso8601String(),
        sourceFeature: 'guidebook',
      ),
    ];
  }
}