import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_notifications/presentation/screens/home/home_screen.dart';
import 'package:custom_notifications/presentation/screens/create/create_screen.dart';
import 'package:custom_notifications/presentation/screens/history/history_screen.dart';
import 'package:custom_notifications/presentation/screens/settings/settings_screen.dart';
import 'package:custom_notifications/presentation/shared/scaffold_with_bottom_nav.dart';

/// Named route paths — reference these instead of raw strings.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String create = '/create';
  static const String history = '/history';
  static const String settings = '/settings';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter instance exposed as a Riverpod provider.
///
/// Uses [StatefulShellRoute.indexedStack] so each tab keeps its own
/// navigation stack and scroll position when the user switches tabs.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.create,
                builder: (context, state) => const CreateScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
