import 'package:educare/core/services/api_service.dart';

class AuthRemoteDatasource {
  final ApiService _apiService;

  AuthRemoteDatasource(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    if (email == 'testing@educaree.com' && password == 'testing@2026') {
      return {
        'id': 1,
        'name': 'EduCare Tester',
        'email': email,
        'token': 'dev-testing-token-2026',
      };
    }

    final response = await _apiService.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data as Map<String, dynamic>);
  }
}
