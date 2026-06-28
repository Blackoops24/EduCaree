import 'package:educare/features/authentication/domain/entities/user.dart';
import 'package:educare/features/authentication/domain/repositories/auth_repository.dart';
import 'package:educare/features/authentication/domain/usecases/login_usecase.dart';
import 'package:educare/features/authentication/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    return User(id: 1, name: 'Tester', email: email, token: 'token');
  }

  @override
  Future<void> changePassword(String email, String currentPassword, String newPassword) async {}

  @override
  Future<User> updateProfile(User currentUser, String name, String email) async {
    return User(id: currentUser.id, name: name, email: email, token: currentUser.token);
  }
}

void main() {
  test('change password rejects the wrong current password', () async {
    final viewModel = AuthViewModel(LoginUseCase(_FakeAuthRepository()));
    await viewModel.login('tester@example.com', 'current-password');

    expect(
      await viewModel.changePassword(
        currentPassword: 'wrong-password',
        newPassword: 'new-password',
      ),
      'Current password is incorrect',
    );
    expect(
      await viewModel.changePassword(
        currentPassword: 'current-password',
        newPassword: 'new-password',
      ),
      isNull,
    );
    expect(
      await viewModel.changePassword(
        currentPassword: 'current-password',
        newPassword: 'another-password',
      ),
      'Current password is incorrect',
    );
  });
}
