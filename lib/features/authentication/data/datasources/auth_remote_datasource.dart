import 'package:educare/core/services/api_service.dart';

class AuthRemoteDatasource {
  final ApiService _apiService;

  AuthRemoteDatasource(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map<String, dynamic>);
    _apiService.setAuthToken(data['token'] as String?);
    return data;
  }

  Future<void> changePassword(String email, String currentPassword, String newPassword) async {
    await _apiService.post('/auth/change-password', data: {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<Map<String, dynamic>> updateProfile(int id, String name, String email) async {
    final response = await _apiService.put('/auth/profile/$id', data: {
      'name': name,
      'email': email,
    });
    return Map<String, dynamic>.from(response.data as Map);
  }
}
