import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_notify/main.dart';

void main() {
  testWidgets('App launches with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: CustomNotifyApp()),
    );
    // Use pump() instead of pumpAndSettle() because the HomeScreen
    // shows a CircularProgressIndicator while the DB stream loads,
    // which never "settles" in a test without a real database.
    await tester.pump();

    // All four bottom nav tabs should be visible
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Create'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
