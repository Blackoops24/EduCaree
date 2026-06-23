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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          final brandingPanel = Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 56),
                ),
                const SizedBox(height: 28),
                const Text(
                  'EduCare',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'School operations, academics, staff, fees, transport and communication in one place.',
                  style: TextStyle(fontSize: 18, height: 1.5, color: Colors.white),
                ),
                const SizedBox(height: 28),
                _buildFeaturePoint('Unified school administration dashboard'),
                _buildFeaturePoint('Fast access to student and staff workflows'),
                _buildFeaturePoint('Notifications, reports, and activity tracking'),
              ],
            ),
          );

          final authPanel = Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign in', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(
                      'Access your dashboard and continue managing daily school operations.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54, height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    AuthForm(
                      loading: authState.loading,
                      error: authState.error,
                      onSubmit: (email, password) {
                        ref.read(authViewModelProvider.notifier).login(email, password);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? '),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.registration),
                          child: const Text('Register now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: brandingPanel),
                Expanded(child: authPanel),
              ],
            );
          }

          return Column(
            children: [
              Expanded(flex: 4, child: brandingPanel),
              Expanded(flex: 6, child: authPanel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeaturePoint(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
