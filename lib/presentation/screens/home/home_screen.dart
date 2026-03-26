import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/domain/services/notification_service.dart';
import 'package:custom_notify/presentation/providers/database_provider.dart';
import 'package:custom_notify/presentation/providers/notification_list_provider.dart';
import 'package:custom_notify/presentation/shared/notification_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notifications'),
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Something went wrong.\n$err',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.error),
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return _EmptyState(
              onCreateTap: () => _navigateToCreate(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.spacingMd),
            itemCount: notifications.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSizes.spacingSm),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return NotificationCard(
                item: item,
                onTap: () {
                  // Navigate to edit screen (full-screen, over bottom nav).
                  context.push('${AppRoutes.edit}/${item.id}');
                },
                onToggle: (isActive) => _toggleActive(
                  ref,
                  context,
                  item.id,
                  isActive,
                ),
                onDelete: () => _deleteNotification(ref, context, item.id),
              );
            },
          );
        },
      ),
      // FAB to create a new notification from the Home tab.
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.textPrimary,
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    HapticFeedback.lightImpact();
    // Open the Create screen as a full-screen overlay.
    context.push(AppRoutes.create);
  }

  Future<void> _toggleActive(
    WidgetRef ref,
    BuildContext context,
    String id,
    bool isActive,
  ) async {
    try {
      await ref
          .read(notificationServiceProvider)
          .toggleActive(id, isActive: isActive);
      // Brief, non-disruptive status feedback.
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isActive ? AppStrings.notificationActive : AppStrings.notificationPaused,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } on NotificationLimitException catch (e) {
      HapticFeedback.heavyImpact();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            action: SnackBarAction(
              label: 'UPGRADE',
              onPressed: () => context.push(AppRoutes.premium),
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteNotification(
    WidgetRef ref,
    BuildContext context,
    String id,
  ) async {
    HapticFeedback.heavyImpact();

    // Snapshot the item before deleting so we can restore on undo.
    final service = ref.read(notificationServiceProvider);
    final snapshot = await service.getById(id);
    await service.deleteNotification(id);

    if (!context.mounted) return;

    // Clear any previous snackbar to prevent stacking.
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.notificationDeleted),
        duration: const Duration(seconds: 5),
        action: snapshot != null
            ? SnackBarAction(
                label: 'UNDO',
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  try {
                    await service.createNotification(snapshot);
                  } on NotificationLimitException {
                    // Edge case: user hit the limit between delete and undo.
                    // Silently fail — the notification is already gone.
                  }
                },
              )
            : null,
      ),
    );
  }
}

/// Empty state shown when there are no notifications yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTap});

  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              'No notifications yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingSm),
            Text(
              'Tap the button below to create your first notification.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingLg),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Create Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
