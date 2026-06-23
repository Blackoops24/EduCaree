import 'package:educare/core/services/api_service.dart';

class AttendanceService {
  final ApiService _apiService;

  AttendanceService(this._apiService);

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _apiService.get(path, queryParameters: queryParameters);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? data}) {
    return _apiService.post(path, data: data);
  }
}
