import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/revenuecat_service.dart';

/// Provides the RevenueCat service singleton.
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

/// Streams premium status changes (purchases, restorations, expirations).
///
/// Starts by checking the current status, then emits on every change.
/// UI widgets can watch this to gate premium features in real time.
final premiumStatusProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(revenueCatServiceProvider);

  // Emit the current status first so the UI has an immediate value.
  yield await service.isPremium();

  // Then stream all future changes.
  yield* service.premiumStatusStream;
});
