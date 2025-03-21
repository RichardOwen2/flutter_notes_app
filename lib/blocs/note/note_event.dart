abstract class NoteEvent {}

class GetNotes extends NoteEvent {}

class GetArchivedNotes extends NoteEvent {}

class CreateNote extends NoteEvent {
  final String title;
  final String body;

  CreateNote({required this.title, required this.body});
}

class GetNoteById extends NoteEvent {
  final String noteId;

  GetNoteById(this.noteId);
}

class ArchiveNote extends NoteEvent {
  final String noteId;

  ArchiveNote(this.noteId);
}

class UnarchiveNote extends NoteEvent {
  final String noteId;

  UnarchiveNote(this.noteId);
}

class DeleteNote extends NoteEvent {
  final String noteId;

  DeleteNote(this.noteId);
}
