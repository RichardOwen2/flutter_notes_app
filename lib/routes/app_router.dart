import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app_2/injection_container.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/notes_page.dart';
import '../pages/archived_notes_page.dart';
import '../layouts/auth_layout.dart';
import '../layouts/app_layout.dart';

final secureStorage = sl<FlutterSecureStorage>();

class AppRouter {
  static GoRouter generate(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/notes' : '/login',
      redirect: (context, state) async {
        final token = await secureStorage.read(key: 'accessToken');
        final path = state.uri.toString();
        final loggingIn = path == '/login' || path == '/register';

        if (token == null && !loggingIn) {
          return '/login';
        }

        if (token != null && loggingIn) {
          return '/notes';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => AuthLayout(child: LoginPage()),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => AuthLayout(child: RegisterPage()),
        ),
        GoRoute(
          path: '/notes',
          builder: (context, state) => AppLayout(child: NotesPage()),
        ),
        GoRoute(
          path: '/notes/archived',
          builder: (context, state) => AppLayout(child: ArchivedNotesPage()),
        ),
      ],
    );
  }
}
