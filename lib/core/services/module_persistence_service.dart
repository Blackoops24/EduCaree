import 'package:dio/dio.dart';
import 'package:educare/core/services/api_service.dart';

class ModulePersistenceService {
  ModulePersistenceService._();

  static final ModulePersistenceService instance = ModulePersistenceService._();
  final ApiService _api = ApiService();
  bool enabled = true;

  Future<Map<String, dynamic>?> load(String moduleKey) async {
    if (!enabled) return null;
    try {
      final response = await _api.get('/api/state/$moduleKey');
      final body = Map<String, dynamic>.from(response.data as Map);
      return Map<String, dynamic>.from(body['data'] as Map);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> save(String moduleKey, Map<String, dynamic> data) async {
    if (!enabled) return;
    await _api.put('/api/state/$moduleKey', data: {'data': data});
  }
}
