import 'package:notes_app_2/models/user_model.dart';

import '../common/ui_state.dart';
import '../../../models/login_response_model.dart';

class AuthState {
  final UiState<LoginResponseModel> loginState;
  final UiState<String> registerState;
  final UiState<UserModel> userState;

  const AuthState({
    required this.loginState,
    required this.registerState,
    this.userState = const Loading(),
  });

  factory AuthState.initial() => AuthState(
        loginState: const Loading(),
        registerState: const Loading(),
        userState: const Loading(),
      );

  AuthState copyWith({
    UiState<LoginResponseModel>? loginState,
    UiState<String>? registerState,
    UiState<UserModel>? userState,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      registerState: registerState ?? this.registerState,
      userState: userState ?? this.userState,
    );
  }
}
