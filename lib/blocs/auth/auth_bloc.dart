import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_2/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../common/ui_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
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

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
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

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthState.initial());
  }
}
