import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_notify/presentation/screens/home/home_screen.dart';
import 'package:custom_notify/presentation/screens/create/create_screen.dart';
import 'package:custom_notify/presentation/screens/history/history_screen.dart';
import 'package:custom_notify/presentation/screens/settings/settings_screen.dart';
import 'package:custom_notify/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:custom_notify/presentation/screens/premium/paywall_screen.dart';
import 'package:custom_notify/presentation/screens/templates/templates_screen.dart';
import 'package:custom_notify/presentation/providers/onboarding_provider.dart';
import 'package:custom_notify/presentation/shared/scaffold_with_bottom_nav.dart';

/// Named route paths — reference these instead of raw strings.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String create = '/create';
  static const String edit = '/create/edit'; // Append /:id at runtime
  static const String history = '/history';
  static const String settings = '/settings';
  static const String templates = '/templates';
  static const String onboarding = '/onboarding';
  static const String premium = '/premium';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Slide-up transition for full-screen overlays (Create, Edit, Premium).
/// Mimics the iOS modal presentation pattern.
CustomTransitionPage<void> _slideUpPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

/// Fade transition for the one-time onboarding gate.
CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

/// GoRouter instance exposed as a Riverpod provider.
///
/// Uses [StatefulShellRoute.indexedStack] so each tab keeps its own
/// navigation stack and scroll position when the user switches tabs.
///
/// On first launch, redirects to [AppRoutes.onboarding]. After the
/// user completes onboarding, the SharedPreferences flag is set and
/// subsequent launches go straight to [AppRoutes.home].
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      // Check onboarding status on every navigation. The provider is
      // cached after the first read, so this is cheap.
      final onboardingAsync = ref.read(onboardingCompleteProvider);
      final isComplete = onboardingAsync.valueOrNull ?? false;
      final isOnOnboarding = state.matchedLocation == AppRoutes.onboarding;

      // Not completed yet and not already on the onboarding page → redirect.
      if (!isComplete && !isOnOnboarding) {
        return AppRoutes.onboarding;
      }
      // Completed but still on onboarding page → go home.
      if (isComplete && isOnOnboarding) {
        return AppRoutes.home;
      }
      return null; // No redirect needed.
    },
    routes: [
      // Onboarding — full-screen, no bottom nav. Fades in.
      GoRoute(
        path: AppRoutes.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
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
                path: AppRoutes.templates,
                builder: (context, state) => const TemplatesScreen(),
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
      // Create screen — full-screen overlay, slides up from bottom.
      GoRoute(
        path: AppRoutes.create,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const CreateScreen(),
        ),
      ),
      // Create from template — pre-fills the form, slides up.
      GoRoute(
        path: '${AppRoutes.create}/template/:templateId',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final templateId = state.pathParameters['templateId']!;
          return _slideUpPage(
            key: state.pageKey,
            child: CreateScreen(templateId: templateId),
          );
        },
      ),
      // Full-screen edit route — slides up over the bottom nav.
      GoRoute(
        path: '${AppRoutes.edit}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _slideUpPage(
            key: state.pageKey,
            child: CreateScreen(editId: id),
          );
        },
      ),
      // Premium paywall — slides up as a modal over the bottom nav.
      GoRoute(
        path: AppRoutes.premium,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const PaywallScreen(),
        ),
      ),
    ],
  );
});
