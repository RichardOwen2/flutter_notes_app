import '../../../models/note_model.dart';
import '../common/ui_state.dart';

class NoteState {
  final UiState<List<NoteModel>> notes;
  final UiState<List<NoteModel>> archivedNotes;
  final UiState<NoteModel> singleNote;
  final UiState<String> actionState;

  const NoteState({
    required this.notes,
    required this.archivedNotes,
    required this.singleNote,
    required this.actionState,
  });

  factory NoteState.initial() => NoteState(
        notes: const Loading(),
        archivedNotes: const Loading(),
        singleNote: const NotLogged(),
        actionState: const NotLogged(),
      );

  NoteState copyWith({
    UiState<List<NoteModel>>? notes,
    UiState<List<NoteModel>>? archivedNotes,
    UiState<NoteModel>? singleNote,
    UiState<String>? actionState,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      archivedNotes: archivedNotes ?? this.archivedNotes,
      singleNote: singleNote ?? this.singleNote,
      actionState: actionState ?? this.actionState,
    );
  }
}
