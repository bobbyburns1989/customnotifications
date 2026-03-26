import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/domain/models/schedule_type.dart';
import 'package:custom_notify/domain/services/template_service.dart';
import 'package:custom_notify/presentation/providers/create_notification_provider.dart';
import 'package:custom_notify/presentation/shared/lock_screen_preview.dart';

/// Create or edit a notification.
///
/// When [editId] is non-null the screen loads that notification from
/// the database and switches to edit mode. Otherwise starts with a
/// blank draft.
class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key, this.editId, this.templateId});

  /// Non-null when editing an existing notification.
  final String? editId;

  /// Non-null when creating from a template (pre-fills the form).
  final String? templateId;

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _didInit = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createNotificationProvider);
    final notifier = ref.read(createNotificationProvider.notifier);

    // Load existing notification for edit mode, or pre-fill from template (once).
    if (!_didInit) {
      _didInit = true;
      if (widget.editId != null) {
        // Schedule the load after the first frame so the provider is ready.
        Future.microtask(() => notifier.loadForEdit(widget.editId!));
      } else if (widget.templateId != null) {
        // Pre-fill from a template.
        Future.microtask(() {
          final template = TemplateService.instance.getById(widget.templateId!);
          if (template != null) {
            notifier.setTitle(template.title);
            notifier.setBody(template.body);
            notifier.setScheduleType(template.scheduleType);
            if (template.weekdays != null) {
              notifier.setWeekdays(template.weekdays!);
            }
            if (template.intervalMinutes != null) {
              notifier.setIntervalMinutes(template.intervalMinutes!);
            }
          }
        });
      }
    }

    // Sync text controllers when the draft changes (e.g. after loadForEdit).
    // Only update if the controller text differs to avoid cursor jumping.
    if (_titleController.text != state.draft.title) {
      _titleController.text = state.draft.title;
    }
    if (_bodyController.text != state.draft.body) {
      _bodyController.text = state.draft.body;
    }

    final isEdit = state.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Notification' : 'Create Notification'),
        // Always show back button — Create is now a full-screen overlay.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(context, state, notifier),
    );
  }

  Widget _buildForm(
    BuildContext context,
    CreateNotificationState state,
    CreateNotificationNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Live lock-screen preview ---
          // Updates in real-time as the user types title and body.
          LockScreenPreview(
            title: state.draft.title,
            body: state.draft.body,
          ),
          const SizedBox(height: AppSizes.spacingLg),

          // --- Error banner ---
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSizes.spacingSm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: AppSizes.iconSizeSm),
                  const SizedBox(width: AppSizes.spacingSm),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),
          ],

          // --- Title field ---
          TextField(
            controller: _titleController,
            onChanged: notifier.setTitle,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'e.g. Take medication',
              errorText: state.titleError,
              counterText: '', // Hide the character counter.
            ),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSizes.spacingMd),

          // --- Body field ---
          TextField(
            controller: _bodyController,
            onChanged: notifier.setBody,
            maxLength: 1000,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Message',
              hintText: 'e.g. Time to take your daily vitamins!',
              errorText: state.bodyError,
              counterText: '',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSizes.spacingLg),

          // --- Schedule type picker ---
          Text(
            'Schedule Type',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.spacingSm),
          _ScheduleTypePicker(
            selected: state.draft.scheduleType,
            onChanged: notifier.setScheduleType,
          ),
          if (state.scheduleError != null) ...[
            const SizedBox(height: AppSizes.spacingXs),
            Text(
              state.scheduleError!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSizes.spacingLg),

          // --- Schedule-type-specific fields ---
          _ScheduleFields(
            scheduleType: state.draft.scheduleType,
            scheduledAt: state.draft.scheduledAt,
            weekdays: state.draft.weekdays ?? [],
            onDateTimeChanged: notifier.setScheduledAt,
            onWeekdaysChanged: notifier.setWeekdays,
          ),
          const SizedBox(height: AppSizes.spacingXl),

          // --- Save button ---
          ElevatedButton(
            onPressed: state.isSaving ? null : () => _onSave(notifier),
            child: state.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(state.isEditing
                    ? 'Save Changes'
                    : 'Create Notification'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(CreateNotificationNotifier notifier) async {
    HapticFeedback.heavyImpact();
    final success = await notifier.save();
    if (success && mounted) {
      if (widget.editId != null) {
        // Edit mode: confirm the save, then pop back.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.changesSaved),
            duration: Duration(seconds: 2),
          ),
        );
        context.pop();
      } else {
        // Create mode: confirm and navigate to Home to see the new notification.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.notificationCreated),
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/');
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Schedule Type Picker
// ---------------------------------------------------------------------------

class _ScheduleTypePicker extends StatelessWidget {
  const _ScheduleTypePicker({
    required this.selected,
    required this.onChanged,
  });

  final ScheduleType selected;
  final ValueChanged<ScheduleType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spacingSm,
      runSpacing: AppSizes.spacingSm,
      children: ScheduleType.values.map((type) {
        final isSelected = type == selected;
        final isPremium = type.isPremium;

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(type.label),
              if (isPremium) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock, size: 14),
              ],
            ],
          ),
          selected: isSelected,
          onSelected: isPremium
              ? null // Disabled for premium types.
              : (_) {
                  HapticFeedback.lightImpact();
                  onChanged(type);
                },
          selectedColor: AppColors.goldLight,
          disabledColor: AppColors.surfaceVariant,
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Schedule-type-specific fields
// ---------------------------------------------------------------------------

class _ScheduleFields extends StatelessWidget {
  const _ScheduleFields({
    required this.scheduleType,
    required this.scheduledAt,
    required this.weekdays,
    required this.onDateTimeChanged,
    required this.onWeekdaysChanged,
  });

  final ScheduleType scheduleType;
  final DateTime scheduledAt;
  final List<int> weekdays;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueChanged<List<int>> onWeekdaysChanged;

  @override
  Widget build(BuildContext context) {
    switch (scheduleType) {
      case ScheduleType.oneTime:
        return _DateTimePicker(
          dateTime: scheduledAt,
          showDate: true,
          showTime: true,
          onChanged: onDateTimeChanged,
        );
      case ScheduleType.daily:
        return _DateTimePicker(
          dateTime: scheduledAt,
          showDate: false,
          showTime: true,
          onChanged: onDateTimeChanged,
        );
      case ScheduleType.weekly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateTimePicker(
              dateTime: scheduledAt,
              showDate: false,
              showTime: true,
              onChanged: onDateTimeChanged,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            _WeekdayPicker(
              selected: weekdays,
              onChanged: onWeekdaysChanged,
            ),
          ],
        );
      // Premium types — show a placeholder message.
      case ScheduleType.interval:
      case ScheduleType.random:
      case ScheduleType.custom:
        return Container(
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline,
                  color: AppColors.textTertiary, size: AppSizes.iconSizeMd),
              const SizedBox(width: AppSizes.spacingSm),
              Expanded(
                child: Text(
                  'Upgrade to Premium to unlock ${scheduleType.label} scheduling.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Date/Time Picker Row
// ---------------------------------------------------------------------------

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    required this.dateTime,
    required this.showDate,
    required this.showTime,
    required this.onChanged,
  });

  final DateTime dateTime;
  final bool showDate;
  final bool showTime;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    // Display in local time for the user.
    final local = dateTime.toLocal();
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();

    return Row(
      children: [
        if (showDate)
          Expanded(
            child: _PickerTile(
              icon: Icons.calendar_today,
              label: dateFormat.format(local),
              onTap: () => _pickDate(context, local),
            ),
          ),
        if (showDate && showTime) const SizedBox(width: AppSizes.spacingSm),
        if (showTime)
          Expanded(
            child: _PickerTile(
              icon: Icons.access_time,
              label: timeFormat.format(local),
              onTap: () => _pickTime(context, local),
            ),
          ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime current) async {
    HapticFeedback.lightImpact();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      // Combine picked date with existing time.
      onChanged(DateTime(
        picked.year,
        picked.month,
        picked.day,
        current.hour,
        current.minute,
      ));
    }
  }

  Future<void> _pickTime(BuildContext context, DateTime current) async {
    HapticFeedback.lightImpact();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked != null) {
      // Combine existing date with picked time.
      onChanged(DateTime(
        current.year,
        current.month,
        current.day,
        picked.hour,
        picked.minute,
      ));
    }
  }
}

/// A tappable row that shows an icon + label, styled like an input field.
class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingMd,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconSizeSm, color: AppColors.textSecondary),
            const SizedBox(width: AppSizes.spacingSm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekday Picker
// ---------------------------------------------------------------------------

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({
    required this.selected,
    required this.onChanged,
  });

  /// Selected days as ISO weekday numbers: 1=Mon … 7=Sun.
  final List<int> selected;
  final ValueChanged<List<int>> onChanged;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repeat on', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSizes.spacingSm),
        Wrap(
          spacing: AppSizes.spacingSm,
          children: List.generate(7, (i) {
            final day = i + 1; // 1=Mon
            final isSelected = selected.contains(day);
            return FilterChip(
              label: Text(_days[i]),
              selected: isSelected,
              selectedColor: AppColors.goldLight,
              onSelected: (_) {
                HapticFeedback.lightImpact();
                final updated = List<int>.from(selected);
                if (isSelected) {
                  updated.remove(day);
                } else {
                  updated.add(day);
                }
                updated.sort();
                onChanged(updated);
              },
            );
          }),
        ),
      ],
    );
  }
}
