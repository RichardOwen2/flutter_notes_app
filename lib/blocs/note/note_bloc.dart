import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_2/models/note_model.dart';
import 'package:notes_app_2/repositories/note_repository.dart';
import 'package:notes_app_2/services/query_client.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../common/ui_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
  final QueryClient queryClient;

  NoteBloc({required this.noteRepository, required this.queryClient})
    : super(NoteState.initial()) {
    on<GetNotes>(_onGetNotes);
    on<GetArchivedNotes>(_onGetArchivedNotes);
    on<CreateNote>(_onCreateNote);
    on<GetNoteById>(_onGetNoteById);
    on<ArchiveNote>(_onArchiveNote);
    on<UnarchiveNote>(_onUnarchiveNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onGetNotes(
    GetNotes event,
    Emitter<NoteState> emit,
  ) async {
    final cache = queryClient.getOrCreate<List<NoteModel>>('GetNotes');

    if (!cache.mustFetch && !event.force) {
      emit(state.copyWith(notes: Success(cache.data!)));
      return;
    }

    emit(state.copyWith(notes: const Loading()));

    try {
      final notes = await noteRepository.getNotes();
      emit(state.copyWith(notes: Success(notes)));
      cache.setData(notes);
    } catch (e) {
      emit(state.copyWith(notes: Error(e.toString())));
    }
  }

  Future<void> _onGetArchivedNotes(
    GetArchivedNotes event,
    Emitter<NoteState> emit,
  ) async {
    final cache = queryClient.getOrCreate<List<NoteModel>>('GetArchivedNotes');

    if (!cache.mustFetch && !event.force) {
      emit(state.copyWith(notes: Success(cache.data!)));
      return;
    }
  
    emit(state.copyWith(archivedNotes: const Loading()));
    try {
      final notes = await noteRepository.getArchivedNotes();
      emit(state.copyWith(archivedNotes: Success(notes)));
      cache.setData(notes);
    } catch (e) {
      emit(state.copyWith(archivedNotes: Error(e.toString())));
    }
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NoteState> emit) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      final note = await noteRepository.createNote(
        title: event.title,
        body: event.body,
      );
      emit(state.copyWith(actionState: Success("Note created: ${note.id}")));

      if (state.notes is Success) {
        final notes = (state.notes as Success<List<NoteModel>>).data;
        notes.add(note);
        emit(state.copyWith(notes: Success(notes)));
        queryClient.getOrCreate<List<NoteModel>>('GetNotes').setData(notes);
      }
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }

  Future<void> _onGetNoteById(
    GetNoteById event,
    Emitter<NoteState> emit,
  ) async {
    final cache = queryClient.getOrCreate<NoteModel>('GetArchivedNotes-${event.noteId}');

    if (!cache.mustFetch && !event.force) {
      emit(state.copyWith(singleNote: Success(cache.data!)));
      return;
    }

    emit(state.copyWith(singleNote: const Loading()));
    try {
      final note = await noteRepository.getNoteById(event.noteId);
      emit(state.copyWith(singleNote: Success(note)));
      cache.setData(note);
    } catch (e) {
      emit(state.copyWith(singleNote: Error(e.toString())));
    }
  }

  Future<void> _onArchiveNote(
    ArchiveNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      await noteRepository.archiveNote(event.noteId);
      emit(state.copyWith(actionState: const Success("Note archived")));
      // add(GetNotes());
      // add(GetArchivedNotes());
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }

  Future<void> _onUnarchiveNote(
    UnarchiveNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      await noteRepository.unarchiveNote(event.noteId);
      emit(state.copyWith(actionState: const Success("Note unarchived")));
      // add(GetNotes());
      // add(GetArchivedNotes());
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    emit(state.copyWith(actionState: const Loading()));
    try {
      await noteRepository.deleteNote(event.noteId);
      emit(state.copyWith(actionState: const Success("Note deleted")));
      // add(GetNotes());
      // add(GetArchivedNotes());
    } catch (e) {
      emit(state.copyWith(actionState: Error(e.toString())));
    }
  }
}
