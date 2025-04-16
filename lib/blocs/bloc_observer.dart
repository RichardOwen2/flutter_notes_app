import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_2/blocs/auth/auth_bloc.dart';
import 'package:notes_app_2/blocs/auth/auth_event.dart';
import 'package:notes_app_2/injection_container.dart';
import 'package:notes_app_2/services/http_service.dart';
import 'package:notes_app_2/services/query_client.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (error is HttpException && error.statusCode == 401) {
      final authBloc = sl<AuthBloc>();
      final queryclient = sl<QueryClient>();
      authBloc.add(Logout());
      queryclient.clearAll();
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }
}
