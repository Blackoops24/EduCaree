import 'package:educare/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> changePassword(String email, String currentPassword, String newPassword);
  Future<User> updateProfile(User currentUser, String name, String email);
}
