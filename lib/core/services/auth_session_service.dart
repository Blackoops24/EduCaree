import 'dart:convert';

import 'package:educare/core/services/api_service.dart';
import 'package:educare/features/authentication/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionService {
  AuthSessionService._();

  static final AuthSessionService instance = AuthSessionService._();
  static const _sessionKey = 'educare.auth.session';

  SharedPreferences? _preferences;
  User? _user;

  User? get user => _user;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final encoded = _preferences?.getString(_sessionKey);
    if (encoded == null) return;

    try {
      final json = Map<String, dynamic>.from(jsonDecode(encoded) as Map);
      _user = User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        token: json['token'] as String,
      );
      ApiService().setAuthToken(_user!.token);
    } catch (_) {
      await clear();
    }
  }

  Future<void> save(User user) async {
    _user = user;
    ApiService().setAuthToken(user.token);
    await _preferences?.setString(
      _sessionKey,
      jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'token': user.token,
      }),
    );
  }

  Future<void> clear() async {
    _user = null;
    ApiService().setAuthToken(null);
    await _preferences?.remove(_sessionKey);
  }
}
