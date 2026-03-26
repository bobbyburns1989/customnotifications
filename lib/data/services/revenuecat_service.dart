import 'dart:async';
import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/utils/logger.dart';

/// Wrapper around the RevenueCat SDK for managing premium subscriptions.
///
/// Handles initialization, premium status checks, purchasing, and
/// restoring purchases. API keys are platform-specific.
///
/// Usage:
///   await RevenueCatService.instance.initialize();
///   final isPremium = await RevenueCatService.instance.isPremium();
class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService instance = RevenueCatService._();

  // TODO: Replace with real RevenueCat API keys before testing.
  static const String _iosApiKey = 'appl_TODO_REPLACE_WITH_IOS_KEY';
  static const String _androidApiKey = 'goog_TODO_REPLACE_WITH_ANDROID_KEY';

  /// The entitlement identifier configured in the RevenueCat dashboard.
  static const String _entitlementId = 'premium';

  final _premiumController = StreamController<bool>.broadcast();

  /// Stream that emits whenever the premium status changes.
  /// Widgets can watch this to react to purchases/expirations.
  Stream<bool> get premiumStatusStream => _premiumController.stream;

  bool _initialized = false;

  /// Initialize the RevenueCat SDK. Call once at app startup.
  ///
  /// Safe to call multiple times — returns immediately if already initialized.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final apiKey = Platform.isIOS ? _iosApiKey : _androidApiKey;

      await Purchases.configure(
        PurchasesConfiguration(apiKey),
      );

      // Listen for customer info changes (purchase, restore, expiration).
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        final premium = customerInfo
                .entitlements.active[_entitlementId]?.isActive ??
            false;
        _premiumController.add(premium);
        Logger.info(
          'Premium status changed: $premium',
          tag: 'RevenueCat',
        );
      });

      _initialized = true;
      Logger.info('RevenueCat initialized', tag: 'RevenueCat');
    } catch (e) {
      // Don't crash the app if RevenueCat fails to initialize.
      // The app works fine on the free tier without it.
      Logger.info('RevenueCat init failed: $e', tag: 'RevenueCat');
    }
  }

  /// Check whether the current user has an active premium entitlement.
  Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo
              .entitlements.active[_entitlementId]?.isActive ??
          false;
    } catch (e) {
      Logger.info('Failed to check premium status: $e', tag: 'RevenueCat');
      return false;
    }
  }

  /// Purchase the premium subscription.
  ///
  /// Fetches the current offering from RevenueCat and purchases the
  /// first available package (monthly subscription).
  /// Returns true if the purchase succeeded, false otherwise.
  Future<bool> purchase() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      if (current == null || current.availablePackages.isEmpty) {
        Logger.info('No offerings available', tag: 'RevenueCat');
        return false;
      }

      // Purchase the first available package (should be the monthly sub).
      final package = current.availablePackages.first;
      await Purchases.purchasePackage(package);

      Logger.info('Purchase successful', tag: 'RevenueCat');
      return true;
    } on PurchasesErrorCode catch (e) {
      // User cancelled is not an error — just return false.
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        Logger.info('Purchase cancelled by user', tag: 'RevenueCat');
        return false;
      }
      Logger.info('Purchase failed: $e', tag: 'RevenueCat');
      return false;
    } catch (e) {
      Logger.info('Purchase failed: $e', tag: 'RevenueCat');
      return false;
    }
  }

  /// Restore previous purchases (e.g. after reinstall or new device).
  ///
  /// Returns true if premium was restored, false otherwise.
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      final premium = customerInfo
              .entitlements.active[_entitlementId]?.isActive ??
          false;
      Logger.info('Restore complete, premium: $premium', tag: 'RevenueCat');
      return premium;
    } catch (e) {
      Logger.info('Restore failed: $e', tag: 'RevenueCat');
      return false;
    }
  }

  /// Clean up resources.
  void dispose() {
    _premiumController.close();
  }
}
