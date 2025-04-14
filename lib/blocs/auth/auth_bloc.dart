import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_2/repositories/auth_repository.dart';
import 'package:notes_app_2/services/http_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../common/ui_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    on<Login>(_onLogin);
    on<Register>(_onRegister);
    on<Logout>(_onLogout);
    on<GetCurrentUser>(_onGetCurrentUser);
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginState: const Loading()));
    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(loginState: Success(result)));
    } catch (e) {
      emit(state.copyWith(loginState: Error(e.toString())));
    }
  }

  Future<void> _onRegister(Register event, Emitter<AuthState> emit) async {
    emit(state.copyWith(registerState: const Loading()));
    try {
      final message = await authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(registerState: Success(message)));
    } catch (e) {
      emit(state.copyWith(registerState: Error(e.toString())));
    }
  }

  Future<void> _onGetCurrentUser(GetCurrentUser event, Emitter<AuthState> emit) async {
    emit(state.copyWith(userState: const Loading()));
    try {
      final user = await authRepository.getCurrentUser();
      emit(state.copyWith(userState: Success(user)));
    } catch (e) {
      if (e is HttpException) {
        if (e.statusCode == 401) {
          emit(state.copyWith(userState: const Unauthenticate()));
          return;
        }
      }

      emit(state.copyWith(userState: Error(e.toString())));
    }
  }

  void _onLogout(Logout event, Emitter<AuthState> emit) {
    emit(AuthState.initial());
  }
}
