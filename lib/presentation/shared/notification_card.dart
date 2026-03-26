import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/domain/models/notification_item.dart';

/// Displays a single notification as a card with toggle, tap-to-edit,
/// and swipe-to-delete.
///
/// Uses the theme card styling (14px radius, outlined border).
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final NotificationItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      // Confirm before deleting.
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMd,
              vertical: AppSizes.spacingSm,
            ),
            child: Row(
              children: [
                // Left side: text content.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with schedule badge.
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: item.isActive
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingSm),
                          _ScheduleBadge(type: item.scheduleType.label),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingXs),
                      // Body preview.
                      Text(
                        item.body,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: item.isActive
                                      ? AppColors.textSecondary
                                      : AppColors.textTertiary,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.spacingXs),
                      // Next fire time.
                      Text(
                        _formatNextFire(item),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                      ),
                    ],
                  ),
                ),
                // Right side: active toggle.
                Switch.adaptive(
                  value: item.isActive,
                  activeColor: AppColors.gold,
                  onChanged: (value) {
                    HapticFeedback.mediumImpact();
                    onToggle(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    HapticFeedback.heavyImpact();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Notification'),
        content: Text('Delete "${item.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Formats the next fire time in a user-friendly way.
  String _formatNextFire(NotificationItem item) {
    final local = item.scheduledAt.toLocal();
    final now = DateTime.now();
    final diff = local.difference(now);

    // For one-time notifications, show the full date + time.
    if (item.scheduleType.name == 'oneTime') {
      return DateFormat.yMMMd().add_jm().format(local);
    }

    // For recurring, show the time of day.
    final timeStr = DateFormat.jm().format(local);
    if (item.scheduleType.name == 'daily') {
      return 'Daily at $timeStr';
    }
    if (item.scheduleType.name == 'weekly' && item.weekdays != null) {
      final dayNames = item.weekdays!.map(_shortDayName).join(', ');
      return '$dayNames at $timeStr';
    }

    // Fallback: relative or absolute time.
    if (diff.isNegative) {
      return 'Past due';
    }
    return DateFormat.yMMMd().add_jm().format(local);
  }

  String _shortDayName(int day) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[day - 1];
  }
}

/// A small chip badge showing the schedule type label.
class _ScheduleBadge extends StatelessWidget {
  const _ScheduleBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.goldDark,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
