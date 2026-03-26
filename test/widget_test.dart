import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/presentation/shared/scaffold_with_bottom_nav.dart';

void main() {
  testWidgets('Bottom nav shows all four tab labels', (
    WidgetTester tester,
  ) async {
    // Build the bottom nav scaffold in isolation, avoiding full app
    // initialization (OS services, database, RevenueCat, etc.).
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) =>
              ScaffoldWithBottomNav(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const Placeholder(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/templates',
                builder: (_, __) => const Placeholder(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/history',
                builder: (_, __) => const Placeholder(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const Placeholder(),
              ),
            ]),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    await tester.pump();

    // All four bottom nav tabs should be visible with correct labels.
    expect(find.text(AppStrings.tabHome), findsOneWidget);
    expect(find.text(AppStrings.tabTemplates), findsOneWidget);
    expect(find.text(AppStrings.tabHistory), findsOneWidget);
    expect(find.text(AppStrings.tabSettings), findsOneWidget);
  });
}
