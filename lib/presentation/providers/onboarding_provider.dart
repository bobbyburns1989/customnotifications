import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used in SharedPreferences to track whether onboarding is complete.
const String _onboardingKey = 'onboarding_complete';

/// Provides the SharedPreferences instance (async initialization).
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// Whether the user has completed onboarding.
///
/// Returns `false` on first launch (key doesn't exist), `true` after
/// [completeOnboarding] is called. Used by the router to decide
/// whether to show the onboarding screen or go straight to home.
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(_onboardingKey) ?? false;
});

/// Marks onboarding as complete in SharedPreferences.
///
/// Call this when the user finishes the onboarding flow.
/// After calling, invalidate [onboardingCompleteProvider] so the
/// router picks up the new value.
Future<void> completeOnboarding(WidgetRef ref) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  await prefs.setBool(_onboardingKey, true);
  ref.invalidate(onboardingCompleteProvider);
}
