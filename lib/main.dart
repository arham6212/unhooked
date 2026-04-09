import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/navigation/app_router.dart';
import 'core/design_system/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Check auth on app start
    Future.microtask(() {
      ref.read(authProvider.notifier).checkAuthStatus();
    });

    return MaterialApp.router( // ✅ IMPORTANT
      debugShowCheckedModeBanner: false,

      routerConfig: ref.watch(routerProvider), // ✅ CONNECT GO ROUTER

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}