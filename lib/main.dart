import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes_app_2/blocs/auth/auth_bloc.dart';
import 'package:notes_app_2/blocs/auth/auth_event.dart';
import 'package:notes_app_2/blocs/auth/auth_state.dart';
import 'package:notes_app_2/blocs/common/ui_state.dart';
import 'package:notes_app_2/blocs/note/note_bloc.dart';
import 'package:notes_app_2/repositories/auth_repository.dart';
import 'package:notes_app_2/repositories/note_repository.dart';
import 'package:notes_app_2/theme/app_theme.dart';
import 'package:notes_app_2/utils/theme_utils.dart';
import 'injection_container.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // DI init

  // final storage = sl<FlutterSecureStorage>();
  // final token = await storage.read(key: 'accessToken');
  // final bool isLoggedIn = token != null;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final bool isLoggedIn;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  AuthBloc(authRepository: sl<AuthRepository>())
                    ..add(GetCurrentUser()),
        ),
        BlocProvider(
          create: (_) => NoteBloc(noteRepository: sl(), queryClient: sl()),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.userState is Loading) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          final isLoggedIn = state.userState is Success;
          final router = AppRouter.generate(isLoggedIn);

          return MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            theme: theme.light(),
          );
        },
      ),
    );
  }
}
