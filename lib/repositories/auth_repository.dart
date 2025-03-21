import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes_app_2/injection_container.dart';
import 'package:notes_app_2/models/login_response_model.dart';
import 'package:notes_app_2/models/user_model.dart';
import 'package:notes_app_2/services/http_service.dart';
import 'package:notes_app_2/utils/constants.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository({required this.httpService});

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await httpService.post(
      ApiRoutes.register,
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response['status'] == 'success') {
      return response['message'];
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await httpService.post(
      ApiRoutes.login,
      body: {'email': email, 'password': password},
    );

    final result = LoginResponseModel.fromJson(response);

    final storage = sl<FlutterSecureStorage>();
    await storage.write(key: 'accessToken', value: result.accessToken);

    return result;
  }

  Future<UserModel> getCurrentUser() async {
    final response = await httpService.get(ApiRoutes.getUserProfile);

    return UserModel.fromJson(response['data']);
  }
}
