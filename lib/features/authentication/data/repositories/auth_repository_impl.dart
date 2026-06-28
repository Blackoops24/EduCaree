import 'package:educare/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:educare/features/authentication/data/models/user_model.dart';
import 'package:educare/features/authentication/domain/entities/user.dart';
import 'package:educare/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<User> login(String email, String password) async {
    final data = await _remoteDatasource.login(email, password);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> changePassword(String email, String currentPassword, String newPassword) {
    return _remoteDatasource.changePassword(email, currentPassword, newPassword);
  }

  @override
  Future<User> updateProfile(User currentUser, String name, String email) async {
    final data = await _remoteDatasource.updateProfile(currentUser.id, name, email);
    return User(
      id: currentUser.id,
      name: data['name'] as String,
      email: data['email'] as String,
      token: currentUser.token,
    );
  }
}
