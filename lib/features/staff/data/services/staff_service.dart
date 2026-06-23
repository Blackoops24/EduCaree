import 'package:educare/core/services/api_service.dart';

class StaffService {
  final ApiService _apiService;

  StaffService(this._apiService);

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _apiService.get(path, queryParameters: queryParameters);
  }

  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiService.post(path, data: data, queryParameters: queryParameters);
  }
}
