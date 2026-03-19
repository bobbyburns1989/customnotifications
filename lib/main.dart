import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_notifications/core/constants/app_strings.dart';
import 'package:custom_notifications/core/routing/app_router.dart';
import 'package:custom_notifications/core/theme/app_theme.dart';
import 'package:custom_notifications/core/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.info('Starting ${AppStrings.appName}', tag: 'App');
  runApp(const ProviderScope(child: CustomNotificationsApp()));
}

/// Root widget — configures theme, routing, and the Riverpod scope.
class CustomNotificationsApp extends ConsumerWidget {
  const CustomNotificationsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
