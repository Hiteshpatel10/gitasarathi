import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/theme_provider.dart';
import 'package:app/core/theme/font_size_provider.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/features/auth/repository/auth_repository.dart';
import 'package:app/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Sign-In v7 singleton
  await AuthRepository.initialize();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        cacheServiceProvider.overrideWithValue(CacheService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontSizeProvider.notifier).scaleFactor;
    // We also need to watch the provider itself so it rebuilds when changed
    ref.watch(fontSizeProvider);

    return MaterialApp.router(
      title: 'GitaSarathi',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: goRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
          ),
          child: child!,
        );
      },
    );
  }
}
