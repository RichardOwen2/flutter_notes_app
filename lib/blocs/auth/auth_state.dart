import '../common/ui_state.dart';
import '../../../models/login_response_model.dart';

class AuthState {
  final UiState<LoginResponseModel> loginState;
  final UiState<String> registerState;

  const AuthState({
    required this.loginState,
    required this.registerState,
  });

  factory AuthState.initial() => AuthState(
        loginState: const NotLogged(),
        registerState: const NotLogged(),
      );

  AuthState copyWith({
    UiState<LoginResponseModel>? loginState,
    UiState<String>? registerState,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      registerState: registerState ?? this.registerState,
    );
  }
}
