import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/core/theme/app_theme.dart';
import 'package:custom_notify/core/utils/logger.dart';
import 'package:custom_notify/data/services/notification_plugin_service.dart';
import 'package:custom_notify/domain/models/history_action.dart';
import 'package:custom_notify/data/services/revenuecat_service.dart';
import 'package:custom_notify/domain/services/background_sync_service.dart';
import 'package:custom_notify/presentation/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.info('Starting ${AppStrings.appName}', tag: 'App');

  // Initialize the notification plugin (timezone + platform settings).
  // This does NOT prompt for permissions — that happens later.
  await NotificationPluginService.instance.init();

  // Register WorkManager periodic sync (30-min interval) so scheduled
  // notifications survive app kills and device reboots.
  await BackgroundSyncService.initialize();

  // Initialize RevenueCat for premium subscription management.
  // Uses platform-specific API keys (TODO placeholders until configured).
  await RevenueCatService.instance.initialize();

  // Create the ProviderContainer so we can access services from the
  // notification tap callback (which fires outside the widget tree).
  final container = ProviderContainer();

  // Wire the notification tap callback to record a "tapped" history entry.
  NotificationPluginService.instance.onNotificationTap = (payload) {
    if (payload != null) {
      container
          .read(historyServiceProvider)
          .recordEvent(payload, HistoryAction.tapped);
    }
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CustomNotifyApp(),
    ),
  );
}

/// Root widget — configures theme, routing, and the Riverpod scope.
///
/// Also acts as an app lifecycle listener: re-syncs all pending OS
/// notifications every time the app returns to the foreground.
class CustomNotifyApp extends ConsumerStatefulWidget {
  const CustomNotifyApp({super.key});

  @override
  ConsumerState<CustomNotifyApp> createState() => _CustomNotifyAppState();
}

class _CustomNotifyAppState extends ConsumerState<CustomNotifyApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: _onAppResumed,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  /// Re-sync scheduled notifications when the app returns to foreground.
  /// Handles cases where the OS cancelled pending notifications while
  /// the app was in the background or suspended.
  void _onAppResumed() {
    Logger.info('App resumed — syncing notifications', tag: 'Lifecycle');
    ref.read(scheduleServiceProvider).syncAll();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
