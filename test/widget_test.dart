import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_notifications/main.dart';

void main() {
  testWidgets('App launches with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: CustomNotificationsApp()),
    );
    await tester.pumpAndSettle();

    // All four bottom nav tabs should be visible
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Create'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
