import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/core/providers.dart';
import 'package:educare/core/services/auth_session_service.dart';
import 'package:educare/core/theme/app_theme.dart';
import 'package:educare/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSessionService.instance.initialize();
  runApp(const ProviderScope(child: EduCareApp()));
}

class EduCareApp extends ConsumerWidget {
  const EduCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'EduCare School ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );
  }
}
