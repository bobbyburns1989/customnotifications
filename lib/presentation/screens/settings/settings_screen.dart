import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/presentation/providers/database_provider.dart';
import 'package:custom_notify/presentation/providers/premium_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingMd),
        children: [
          // --- Premium section ---
          const _SectionHeader(title: 'Subscription'),
          const SizedBox(height: AppSizes.spacingSm),
          const _PremiumTile(),
          const SizedBox(height: AppSizes.spacingLg),

          // --- Notifications section ---
          const _SectionHeader(title: 'Notifications'),
          const SizedBox(height: AppSizes.spacingSm),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Permissions',
            subtitle: 'Allow CustomNotify to send notifications',
            onTap: () => _requestPermissions(context, ref),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          const _PendingCountTile(),
          const SizedBox(height: AppSizes.spacingLg),

          // --- Data section ---
          const _SectionHeader(title: 'Data'),
          const SizedBox(height: AppSizes.spacingSm),
          _SettingsTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Clear Old History',
            subtitle: 'Remove history entries older than 30 days',
            onTap: () => _clearOldHistory(context, ref),
          ),
          const SizedBox(height: AppSizes.spacingLg),

          // --- About section ---
          const _SectionHeader(title: 'About'),
          const SizedBox(height: AppSizes.spacingSm),
          const _SettingsTile(
            icon: Icons.info_outline,
            title: AppStrings.appName,
            subtitle: 'Version 1.0.0',
            onTap: null,
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final plugin = ref.read(notificationPluginProvider);
    final granted = await plugin.requestPermissions();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? 'Notification permissions granted'
                : 'Permissions denied — enable in system Settings',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _clearOldHistory(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final dao = ref.read(historyDaoProvider);
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
    final deleted = await dao.deleteOlderThan(cutoff);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            deleted > 0
                ? 'Removed $deleted old history entries'
                : 'No old entries to remove',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

/// Shows Premium subscription status and links to the paywall.
/// Displays "Active" for premium users, or "Upgrade" for free users.
class _PremiumTile extends ConsumerWidget {
  const _PremiumTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumStatusProvider).valueOrNull ?? false;

    return _SettingsTile(
      icon: Icons.workspace_premium_outlined,
      title: isPremium ? 'Premium Active' : 'Upgrade to Premium',
      subtitle: isPremium
          ? 'You have unlimited access'
          : 'Unlock unlimited notifications & more',
      onTap: isPremium ? null : () {
        HapticFeedback.lightImpact();
        context.push(AppRoutes.premium);
      },
    );
  }
}

/// Displays the current count of pending OS notifications.
/// Uses a Riverpod FutureProvider that auto-disposes, so the count
/// refreshes each time the Settings screen is revisited.
class _PendingCountTile extends ConsumerWidget {
  const _PendingCountTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(pendingCountProvider);
    final count = countAsync.valueOrNull ?? 0;

    return _SettingsTile(
      icon: Icons.schedule_outlined,
      title: 'Pending Notifications',
      subtitle: '$count of 60 slots used',
      onTap: null,
    );
  }
}

/// Section header label.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
    );
  }
}

/// A single settings row with icon, title, subtitle, and optional tap.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMd,
            vertical: AppSizes.spacingSm,
          ),
          child: Row(
            children: [
              Icon(icon, size: AppSizes.iconSizeMd, color: AppColors.goldDark),
              const SizedBox(width: AppSizes.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spacingXs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
