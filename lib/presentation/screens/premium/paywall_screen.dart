import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/presentation/providers/premium_provider.dart';

/// Custom-branded paywall screen matching the gold theme.
///
/// Shows a feature comparison (Free vs Premium), price, and
/// purchase/restore buttons. Navigated to from limit errors
/// or the Settings screen.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isPurchasing = false;
  bool _isRestoring = false;

  Future<void> _purchase() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);
    HapticFeedback.mediumImpact();

    final service = ref.read(revenueCatServiceProvider);
    final success = await service.purchase();

    if (!mounted) return;
    setState(() => _isPurchasing = false);

    if (success) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.welcomeToPremium)),
      );
      context.pop();
    } else {
      // Purchase failed or was cancelled — give feedback.
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.purchaseFailed)),
      );
    }
  }

  Future<void> _restore() async {
    if (_isRestoring) return;
    setState(() => _isRestoring = true);
    HapticFeedback.lightImpact();

    final service = ref.read(revenueCatServiceProvider);
    final restored = await service.restorePurchases();

    if (!mounted) return;
    setState(() => _isRestoring = false);

    if (restored) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.premiumRestored)),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.noPreviousPurchase)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text(''),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLg,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingMd),

              // Branding
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 40,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: AppSizes.spacingMd),
              Text(
                'Unlock Premium',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                AppStrings.appTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSizes.spacingLg),

              // Feature comparison
              _buildFeatureList(context),
              const SizedBox(height: AppSizes.spacingLg),

              // Price
              Text(
                '\$0.99 / month',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                'Start with a 3-day free trial',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSizes.spacingLg),

              // Purchase button
              ElevatedButton(
                onPressed: _isPurchasing ? null : _purchase,
                child: _isPurchasing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textPrimary,
                        ),
                      )
                    : const Text('Start Free Trial'),
              ),
              const SizedBox(height: AppSizes.spacingSm),

              // Restore
              TextButton(
                onPressed: _isRestoring ? null : _restore,
                child: _isRestoring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textTertiary,
                        ),
                      )
                    : const Text(
                        'Restore Purchases',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
              ),
              const SizedBox(height: AppSizes.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingMd),
        child: Column(
          children: [
            _FeatureRow(
              title: 'Unlimited notifications',
              freeValue: '10 max',
              premiumValue: 'Unlimited',
            ),
            Divider(height: AppSizes.spacingMd),
            _FeatureRow(
              title: 'Schedule types',
              freeValue: 'Basic',
              premiumValue: 'All types',
            ),
            Divider(height: AppSizes.spacingMd),
            _FeatureRow(
              title: 'Templates',
              freeValue: '10 built-in',
              premiumValue: '50+ templates',
            ),
            Divider(height: AppSizes.spacingMd),
            _FeatureRow(
              title: 'Persistent alerts',
              freeValue: null,
              premiumValue: 'Included',
            ),
            Divider(height: AppSizes.spacingMd),
            _FeatureRow(
              title: 'Analytics',
              freeValue: null,
              premiumValue: 'Included',
            ),
            Divider(height: AppSizes.spacingMd),
            _FeatureRow(
              title: 'Backup & Restore',
              freeValue: null,
              premiumValue: 'Included',
            ),
          ],
        ),
      ),
    );
  }
}

/// A single row in the feature comparison list.
///
/// Shows the feature title with Free and Premium values.
/// A null [freeValue] renders a dash (—) to indicate the feature
/// is not available on the free tier.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.title,
    required this.freeValue,
    required this.premiumValue,
  });

  final String title;
  final String? freeValue;
  final String premiumValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            freeValue ?? '—',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: freeValue != null
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
                ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            premiumValue,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.goldDark,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
