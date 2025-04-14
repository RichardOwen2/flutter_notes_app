abstract class NoteEvent {}

class GetNotes extends NoteEvent {
  final bool force;

  GetNotes({this.force = false});
}

class GetArchivedNotes extends NoteEvent {
  final bool force;

  GetArchivedNotes({this.force = false});
}

class CreateNote extends NoteEvent {
  final String title;
  final String body;

  CreateNote({required this.title, required this.body});
}

class GetNoteById extends NoteEvent {
  final String noteId;
  final bool force;

  GetNoteById(this.noteId, {this.force = false});
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
