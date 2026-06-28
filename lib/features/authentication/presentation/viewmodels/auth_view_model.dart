import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/authentication/domain/entities/user.dart';
import 'package:educare/features/authentication/domain/repositories/auth_repository.dart';
import 'package:educare/features/authentication/domain/usecases/login_usecase.dart';

class AuthState {
  final bool loading;
  final String? error;
  final User? user;

  const AuthState({this.loading = false, this.error, this.user});

  AuthState copyWith({
    bool? loading,
    String? error,
    User? user,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository? _repository;
  String? _activePassword;

  AuthViewModel(this._loginUseCase, [this._repository]) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await _loginUseCase.execute(email, password);
      _activePassword = password;
      state = state.copyWith(user: user, loading: false);
    } catch (error) {
      state = state.copyWith(
        loading: false,
        error: 'Unable to sign in. Please check your credentials and try again.',
      );
    }
  }

  void logout() {
    _activePassword = null;
    state = const AuthState();
  }

  Future<void> updateProfile({required String name, required String email}) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    final updated = _repository == null
        ? User(id: currentUser.id, name: name, email: email, token: currentUser.token)
        : await _repository.updateProfile(currentUser, name, email);
    state = state.copyWith(user: updated);
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      if (_repository == null) {
        if (_activePassword == null || currentPassword != _activePassword) {
          return 'Current password is incorrect';
        }
      } else {
        final email = state.user?.email;
        if (email == null) return 'Sign in again before changing the password';
        await _repository.changePassword(email, currentPassword, newPassword);
      }
      _activePassword = newPassword;
      return null;
    } catch (_) {
      return 'Current password is incorrect';
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
