import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:educare/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModulePersistenceService {
  ModulePersistenceService._();

  static final ModulePersistenceService instance = ModulePersistenceService._();
  final ApiService _api = ApiService();
  bool enabled = true;
  bool remoteEnabled = true;

  Future<Map<String, dynamic>?> load(String moduleKey) async {
    if (!enabled) return null;
    final preferences = await SharedPreferences.getInstance();
    final cacheKey = 'educare.module.$moduleKey';
    final pendingKey = '$cacheKey.pending';
    final encodedCache = preferences.getString(cacheKey);
    final cachedData = encodedCache == null
        ? null
        : Map<String, dynamic>.from(jsonDecode(encodedCache) as Map);
    if (!remoteEnabled) return cachedData;

    if (cachedData != null && preferences.getBool(pendingKey) == true) {
      try {
        await _api.put('/api/state/$moduleKey', data: {'data': cachedData});
        await preferences.setBool(pendingKey, false);
        return cachedData;
      } on DioException {
        return cachedData;
      }
    }

    try {
      final response = await _api.get('/api/state/$moduleKey');
      final body = Map<String, dynamic>.from(response.data as Map);
      final data = Map<String, dynamic>.from(body['data'] as Map);
      await preferences.setString(cacheKey, jsonEncode(data));
      await preferences.setBool(pendingKey, false);
      return data;
    } on DioException catch (error) {
      if (cachedData != null) return cachedData;
      if (error.response?.statusCode == 404) return null;
      return null;
    }
  }

  Future<void> save(String moduleKey, Map<String, dynamic> data) async {
    if (!enabled) return;
    final preferences = await SharedPreferences.getInstance();
    final cacheKey = 'educare.module.$moduleKey';
    final pendingKey = '$cacheKey.pending';
    await preferences.setString(cacheKey, jsonEncode(data));
    await preferences.setBool(pendingKey, true);
    if (!remoteEnabled) return;
    await _api.put('/api/state/$moduleKey', data: {'data': data});
    await preferences.setBool(pendingKey, false);
  }
}
