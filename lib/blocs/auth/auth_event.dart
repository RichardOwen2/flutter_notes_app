abstract class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class Register extends AuthEvent {
  final String name;
  final String email;
  final String password;

  Register({
    required this.name,
    required this.email,
    required this.password,
  });
}

class GetCurrentUser extends AuthEvent {}

class Logout extends AuthEvent {}
