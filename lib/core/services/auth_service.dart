import 'package:educare/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> signIn(String email, String password) {
    return _apiService.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    ).then((response) => Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }
}
