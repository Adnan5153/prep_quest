import 'dart:developer' as developer;

import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/ai_note_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';
import '../../domain/enums/note_filter.dart';
import '../../domain/enums/note_sort.dart';
import '../../domain/enums/note_type.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../datasources/notes_remote_datasource.dart';
import '../models/ai_note_model.dart';
import '../models/highlight_model.dart';
import '../models/note_model.dart';

/// Concrete [NotesRepository] with remote-first local fallback.
class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = false,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final NotesLocalDataSource local;
  final NotesRemoteDatasource? remote;
  final bool preferRemote;
  final DateTime Function() _clock;

  @override
  Future<Result<List<NoteEntity>>> getNotes({
    NoteFilter filter = NoteFilter.all,
    NoteSort sort = NoteSort.newest,
    String? query,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final List<NoteModel> rows = local.readAll();
      final List<NoteEntity> filtered = _filter(rows, filter)
          .where((NoteEntity n) =>
              query == null ||
              _matchesQuery(n, query.toLowerCase()))
          .toList(growable: false);
      final List<NoteEntity> sorted = _sort(filtered, sort);
      final List<NoteEntity> page = offset >= sorted.length
          ? const <NoteEntity>[]
          : sorted.sublist(
              offset,
              offset + limit > sorted.length
                  ? sorted.length
                  : offset + limit,
            );
      return Result.success(
        List<NoteEntity>.unmodifiable(page),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NoteEntity>>> getPinnedNotes({int limit = 8}) async {
    try {
      final List<NoteModel> rows =
          local.readAll().where((NoteModel r) => r.isPinned).toList();
      rows.sort((NoteModel a, NoteModel b) =>
          _parseTime(b.updatedAtIso).compareTo(_parseTime(a.updatedAtIso)));
      return Result.success(
        List<NoteEntity>.unmodifiable(
          rows.take(limit).map((NoteModel r) => r.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<NoteEntity>>> getRecentNotes({int limit = 6}) async {
    try {
      final List<NoteModel> rows = List<NoteModel>.from(local.readAll());
      rows.sort((NoteModel a, NoteModel b) =>
          _parseTime(b.updatedAtIso).compareTo(_parseTime(a.updatedAtIso)));
      return Result.success(
        List<NoteEntity>.unmodifiable(
          rows.take(limit).map((NoteModel r) => r.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity?>> findNoteById(String id) async {
    try {
      final NoteModel? row = local
          .readAll()
          .where((NoteModel r) => r.id == id)
          .cast<NoteModel?>()
          .firstWhere((NoteModel? r) => r != null, orElse: () => null);
      return Result<NoteEntity?>.success(row?.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> createNote(NoteEntity note) async {
    try {
      final NoteModel model = NoteModel.fromEntity(note);
      local.writeOne(model);
      _safePush();
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> updateNote(NoteEntity note) async {
    try {
      final NoteModel model =
          NoteModel.fromEntity(note.copyWith(updatedAtIso: _clock().toIso8601String()));
      local.writeOne(model);
      _safePush();
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      local.removeOne(id);
      _safePush();
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> togglePin(String id) async {
    try {
      final NoteModel? existing = _findLocal(id);
      if (existing == null) {
        return Result<NoteEntity>.failure(
          ErrorHandler.map(
            StateError('Note $id not found'),
            StackTrace.current,
          ),
        );
      }
      final NoteModel next = existing.copyWith(
        isPinned: !existing.isPinned,
        updatedAtIso: _clock().toIso8601String(),
      );
      local.writeOne(next);
      _safePush();
      return Result.success(next.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> toggleFavorite(String id) async {
    try {
      final NoteModel? existing = _findLocal(id);
      if (existing == null) {
        return Result<NoteEntity>.failure(
          ErrorHandler.map(
            StateError('Note $id not found'),
            StackTrace.current,
          ),
        );
      }
      final NoteModel next = existing.copyWith(
        isFavorite: !existing.isFavorite,
        updatedAtIso: _clock().toIso8601String(),
      );
      local.writeOne(next);
      _safePush();
      return Result.success(next.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> saveHighlight(HighlightEntity highlight) async {
    try {
      final HighlightModel model = HighlightModel.fromEntity(highlight);
      final NoteColor color = model.color;
      final NoteEntity note = NoteEntity(
        id: 'highlight-${model.id}',
        title: 'Highlight — ${model.sourceTitle}',
        content: model.text,
        type: NoteType.highlight,
        category: NoteCategory.insight,
        color: color,
        isPinned: false,
        isFavorite: false,
        tags: model.tags,
        attachments: <NoteAttachmentEntity>[
          NoteAttachmentEntity(
            kind: 'highlight',
            itemId: model.itemId,
            title: model.sourceTitle,
            routeName: model.routeName,
            subtitle: model.subtitle,
            iconKey: model.iconKey,
          ),
        ],
        createdAtIso: model.createdAtIso,
        updatedAtIso: _clock().toIso8601String(),
        sourceFeature: model.sourceFeature,
      );
      return createNote(note);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<NoteEntity>> saveAiNote(AiNoteEntity aiNote) async {
    try {
      final AiNoteModel model = AiNoteModel.fromEntity(aiNote);
      final NoteEntity note = model.toEntity().toNoteEntity().copyWith(
            id: 'ai-${model.id}',
          );
      return createNote(note);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      local.clear();
      _safePush();
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------

  NoteModel? _findLocal(String id) {
    for (final NoteModel r in local.readAll()) {
      if (r.id == id) return r;
    }
    return null;
  }

  List<NoteEntity> _filter(List<NoteModel> rows, NoteFilter filter) {
    final List<NoteEntity> out = <NoteEntity>[];
    for (final NoteModel row in rows) {
      final NoteEntity entity = row.toEntity();
      switch (filter) {
        case NoteFilter.all:
          out.add(entity);
          break;
        case NoteFilter.pinned:
          if (entity.isPinned) out.add(entity);
          break;
        case NoteFilter.favorites:
          if (entity.isFavorite) out.add(entity);
          break;
        case NoteFilter.highlights:
          if (entity.type == NoteType.highlight) out.add(entity);
          break;
        case NoteFilter.ai:
          if (entity.type == NoteType.ai) out.add(entity);
          break;
        case NoteFilter.personal:
          if (entity.type == NoteType.personal) out.add(entity);
          break;
      }
    }
    return out;
  }

  List<NoteEntity> _sort(List<NoteEntity> rows, NoteSort sort) {
    final List<NoteEntity> copy = List<NoteEntity>.from(rows);
    switch (sort) {
      case NoteSort.newest:
        copy.sort((NoteEntity a, NoteEntity b) =>
            _parseTime(b.updatedAtIso).compareTo(_parseTime(a.updatedAtIso)));
        break;
      case NoteSort.oldest:
        copy.sort((NoteEntity a, NoteEntity b) =>
            _parseTime(a.updatedAtIso).compareTo(_parseTime(b.updatedAtIso)));
        break;
      case NoteSort.alphabetical:
        copy.sort((NoteEntity a, NoteEntity b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case NoteSort.favoritesFirst:
        copy.sort((NoteEntity a, NoteEntity b) {
          if (a.isFavorite != b.isFavorite) {
            return a.isFavorite ? -1 : 1;
          }
          return _parseTime(b.updatedAtIso)
              .compareTo(_parseTime(a.updatedAtIso));
        });
        break;
      case NoteSort.pinnedFirst:
        copy.sort((NoteEntity a, NoteEntity b) {
          if (a.isPinned != b.isPinned) {
            return a.isPinned ? -1 : 1;
          }
          return _parseTime(b.updatedAtIso)
              .compareTo(_parseTime(a.updatedAtIso));
        });
        break;
    }
    return copy;
  }

  bool _matchesQuery(NoteEntity n, String needle) {
    if (needle.isEmpty) return true;
    if (n.title.toLowerCase().contains(needle)) return true;
    if (n.content.toLowerCase().contains(needle)) return true;
    for (final String tag in n.tags) {
      if (tag.toLowerCase().contains(needle)) return true;
    }
    for (final NoteAttachmentEntity a in n.attachments) {
      if (a.title.toLowerCase().contains(needle)) return true;
      if ((a.subtitle ?? '').toLowerCase().contains(needle)) return true;
    }
    return false;
  }

  DateTime _parseTime(String iso) {
    return DateTime.tryParse(iso) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  void _safePush() {
    final NotesRemoteDatasource? r = remote;
    if (r == null) return;
    Future<void>(() async {
      try {
        await r.push(local.readAll());
      } catch (e, st) {
        developer.log(
          'Notes push failed (best-effort): $e',
          error: e,
          stackTrace: st,
          name: 'NotesRepository',
        );
      }
    });
  }
}
