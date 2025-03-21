import 'package:notes_app_2/models/note_model.dart';
import 'package:notes_app_2/services/http_service.dart';
import 'package:notes_app_2/utils/constants.dart';

class NoteRepository {
  final HttpService httpService;

  NoteRepository({required this.httpService});

  Future<NoteModel> createNote({
    required String title,
    required String body,
  }) async {
    final response = await httpService.post(
      ApiRoutes.createNote,
      body: {'title': title, 'body': body},
    );

    return NoteModel.fromJson(response['data']);
  }

  Future<List<NoteModel>> getNotes() async {
    final response = await httpService.get(ApiRoutes.getNotes);

    final List<dynamic> notesJson = response['data'];

    return notesJson.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<List<NoteModel>> getArchivedNotes() async {
    final response = await httpService.get(ApiRoutes.getArchivedNotes);

    final List<dynamic> notesJson = response['data'];

    return notesJson.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<NoteModel> getNoteById(String noteId) async {
    final response = await httpService.get(ApiRoutes.singleNote(noteId));

    return NoteModel.fromJson(response['data']);
  }

  Future<void> archiveNote(String noteId) async {
    await httpService.post(ApiRoutes.archiveNote(noteId));
  }

  Future<void> unarchiveNote(String noteId) async {
    await httpService.post(ApiRoutes.unarchiveNote(noteId));
  }

  Future<void> deleteNote(String noteId) async {
    await httpService.delete(ApiRoutes.singleNote(noteId));
  }
}
