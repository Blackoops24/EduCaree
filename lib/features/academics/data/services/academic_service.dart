import 'package:educare/core/services/api_service.dart';

class AcademicService {
  final ApiService _apiService;

  AcademicService(this._apiService);

  Future get(String path, {Map<String, dynamic>? queryParameters}) {
    return _apiService.get(path, queryParameters: queryParameters);
  }

  Future post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiService.post(path, data: data, queryParameters: queryParameters);
  }

  Future put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiService.post(path, data: data, queryParameters: queryParameters);
  }

  Future delete(String path, {Map<String, dynamic>? queryParameters}) {
    return _apiService.get(path, queryParameters: queryParameters);
  }
}
