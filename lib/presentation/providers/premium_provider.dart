import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/revenuecat_service.dart';

/// Provides the RevenueCat service singleton.
/// Retained so paywall_screen.dart compiles — unused until RevenueCat is enabled.
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

/// Premium status provider.
///
/// v1.0: Always returns true — all features unlocked for free.
/// When RevenueCat is configured, replace with the stream-based
/// implementation that checks entitlements.
final premiumStatusProvider = StreamProvider<bool>((ref) async* {
  yield true;
});
