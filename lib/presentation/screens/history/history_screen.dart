import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/domain/models/history_action.dart';
import 'package:custom_notify/domain/models/history_entry.dart';
import 'package:custom_notify/presentation/providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: historyAsync.when(
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
        data: (entries) {
          if (entries.isEmpty) {
            return const _EmptyState();
          }

          // Group entries by date for section headers.
          final grouped = _groupByDate(entries);

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.spacingMd),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final group = grouped[index];
              return _DateGroup(
                dateLabel: group.label,
                entries: group.entries,
              );
            },
          );
        },
      ),
    );
  }

  /// Group history entries by calendar date (local time).
  List<_HistoryDateGroup> _groupByDate(List<HistoryEntry> entries) {
    final Map<String, List<HistoryEntry>> map = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final entry in entries) {
      final local = entry.firedAt.toLocal();
      final date = DateTime(local.year, local.month, local.day);

      String label;
      if (date == today) {
        label = 'Today';
      } else if (date == yesterday) {
        label = 'Yesterday';
      } else {
        label = DateFormat.yMMMd().format(local);
      }

      map.putIfAbsent(label, () => []).add(entry);
    }

    // Preserve insertion order (entries are already sorted newest-first,
    // so the first date encountered is the most recent).
    return map.entries
        .map((e) => _HistoryDateGroup(label: e.key, entries: e.value))
        .toList();
  }
}

/// A group of history entries under a single date header.
class _HistoryDateGroup {
  const _HistoryDateGroup({required this.label, required this.entries});
  final String label;
  final List<HistoryEntry> entries;
}

/// Section header + list of entries for a single date.
class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.dateLabel, required this.entries});

  final String dateLabel;
  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.spacingSm,
            top: AppSizes.spacingSm,
          ),
          child: Text(
            dateLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...entries.map((entry) => _HistoryTile(entry: entry)),
        const SizedBox(height: AppSizes.spacingSm),
      ],
    );
  }
}

/// A single history entry row.
class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.jm().format(entry.firedAt.toLocal());

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingSm,
        ),
        child: Row(
          children: [
            // Action icon.
            _ActionIcon(action: entry.action),
            const SizedBox(width: AppSizes.spacingSm),
            // Content.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.spacingXs),
                  Text(
                    entry.body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spacingSm),
            // Time + action label.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: AppSizes.spacingXs),
                _ActionBadge(action: entry.action),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon for each history action type.
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.action});
  final HistoryAction action;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (action) {
      HistoryAction.delivered => (Icons.notifications_active, AppColors.gold),
      HistoryAction.tapped => (Icons.touch_app, AppColors.goldDark),
      HistoryAction.dismissed => (Icons.close, AppColors.textTertiary),
      HistoryAction.snoozed => (Icons.snooze, AppColors.warning),
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Icon(icon, size: AppSizes.iconSizeSm, color: color),
    );
  }
}

/// Small badge showing the action label.
class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.action});
  final HistoryAction action;

  @override
  Widget build(BuildContext context) {
    return Text(
      action.label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
          ),
    );
  }
}

/// Empty state shown when there are no history entries yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              'No history yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingSm),
            Text(
              'Delivered and tapped notifications will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
