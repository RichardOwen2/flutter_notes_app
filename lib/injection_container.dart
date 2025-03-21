import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_app_2/repositories/auth_repository.dart';
import 'package:notes_app_2/repositories/note_repository.dart';
import 'package:notes_app_2/services/http_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => HttpService());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(httpService: sl()),
  );

  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepository(httpService: sl()),
  );
}
