import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes_app_2/blocs/auth/auth_bloc.dart';
import 'package:notes_app_2/blocs/note/note_bloc.dart';
import 'package:notes_app_2/repositories/auth_repository.dart';
import 'package:notes_app_2/repositories/note_repository.dart';
import 'injection_container.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // DI init

  final storage = sl<FlutterSecureStorage>();
  final token = await storage.read(key: 'accessToken');
  final bool isLoggedIn = token != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.generate(isLoggedIn);
  
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: sl<AuthRepository>()),
        ),
        BlocProvider(
          create: (_) => NoteBloc(noteRepository: sl<NoteRepository>()),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
