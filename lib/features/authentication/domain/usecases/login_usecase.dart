import 'package:educare/features/authentication/domain/entities/user.dart';
import 'package:educare/features/authentication/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
