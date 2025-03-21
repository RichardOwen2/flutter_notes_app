class ApiRoutes {
  static const baseUrl = 'https://notes-api.dicoding.dev/v1';

  static const register = '/register';
  static const login = '/login';
  static const getUserProfile = '/users/me';

  static const createNote = '/notes';
  static const getNotes = '/notes';
  static const getArchivedNotes = '/notes/archived';
  static String singleNote(String id) => '/notes/$id';
  static String archiveNote(String id) => '/notes/$id/archive';
  static String unarchiveNote(String id) => '/notes/$id/unarchive';
}
