import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:educare/core/constants/app_constants.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/features/authentication/presentation/viewmodels/auth_view_model.dart';
import 'package:educare/features/authentication/presentation/widgets/auth_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(
      authViewModelProvider,
      (previous, next) {
        if (next.user != null) {
          Future.microtask(() => context.go(AppRoutes.dashboard));
        }
      },
    );
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduCare School ERP'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                AuthForm(
                  loading: authState.loading,
                  error: authState.error,
                  onSubmit: (email, password) {
                    ref.read(authViewModelProvider.notifier).login(email, password);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
