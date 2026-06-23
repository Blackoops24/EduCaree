import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/authentication/domain/entities/user.dart';
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

  AuthViewModel(this._loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await _loginUseCase.execute(email, password);
      state = state.copyWith(user: user, loading: false);
    } catch (error) {
      state = state.copyWith(
        loading: false,
        error: 'Unable to sign in. Please check your credentials and try again.',
      );
    }
  }
}
