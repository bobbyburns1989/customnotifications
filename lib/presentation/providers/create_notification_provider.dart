import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/notification_item.dart';
import '../../domain/models/schedule_type.dart';
import '../../domain/services/notification_service.dart';
import 'database_provider.dart';

/// State for the create/edit notification form.
///
/// Tracks the draft notification, validation errors, and whether we're
/// in create or edit mode. The provider is created per-screen instance
/// via [createNotificationProvider] with an optional existing ID.
class CreateNotificationState {
  const CreateNotificationState({
    required this.draft,
    this.isEditing = false,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.titleError,
    this.bodyError,
    this.scheduleError,
  });

  final NotificationItem draft;
  final bool isEditing;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? titleError;
  final String? bodyError;
  final String? scheduleError;

  CreateNotificationState copyWith({
    NotificationItem? draft,
    bool? isEditing,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? titleError,
    String? bodyError,
    String? scheduleError,
    // Allow clearing nullable fields by passing explicit null.
    bool clearErrorMessage = false,
    bool clearTitleError = false,
    bool clearBodyError = false,
    bool clearScheduleError = false,
  }) {
    return CreateNotificationState(
      draft: draft ?? this.draft,
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      titleError: clearTitleError ? null : (titleError ?? this.titleError),
      bodyError: clearBodyError ? null : (bodyError ?? this.bodyError),
      scheduleError: clearScheduleError ? null : (scheduleError ?? this.scheduleError),
    );
  }
}

/// Creates a blank draft notification with sensible defaults.
NotificationItem _blankDraft() {
  final now = DateTime.now().toUtc();
  return NotificationItem(
    id: const Uuid().v4(),
    title: '',
    body: '',
    scheduleType: ScheduleType.oneTime,
    // Default to 1 hour from now, rounded to the next 5-minute mark.
    scheduledAt: DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1,
      (now.minute / 5).ceil() * 5,
    ).toUtc(),
    createdAt: now,
    updatedAt: now,
  );
}

class CreateNotificationNotifier extends StateNotifier<CreateNotificationState> {
  CreateNotificationNotifier(this._service)
      : super(CreateNotificationState(draft: _blankDraft()));

  final NotificationService _service;

  /// Initialize for editing an existing notification.
  /// Call this right after creating the provider when navigating to edit.
  Future<void> loadForEdit(String id) async {
    state = state.copyWith(isLoading: true);
    final item = await _service.getById(id);
    if (item != null) {
      state = state.copyWith(
        draft: item,
        isEditing: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Notification not found.',
      );
    }
  }

  void setTitle(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(title: value, updatedAt: DateTime.now().toUtc()),
      clearTitleError: true,
      clearErrorMessage: true,
    );
  }

  void setBody(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(body: value, updatedAt: DateTime.now().toUtc()),
      clearBodyError: true,
      clearErrorMessage: true,
    );
  }

  void setScheduleType(ScheduleType type) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        scheduleType: type,
        updatedAt: DateTime.now().toUtc(),
      ),
      clearScheduleError: true,
      clearErrorMessage: true,
    );
  }

  void setScheduledAt(DateTime dateTime) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        scheduledAt: dateTime.toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
      clearScheduleError: true,
    );
  }

  void setWeekdays(List<int> weekdays) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        weekdays: weekdays,
        updatedAt: DateTime.now().toUtc(),
      ),
      clearScheduleError: true,
    );
  }

  void setIntervalMinutes(int minutes) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        intervalMinutes: minutes,
        updatedAt: DateTime.now().toUtc(),
      ),
      clearScheduleError: true,
    );
  }

  /// Validate the form locally before attempting to save.
  /// Returns true if all fields are valid.
  bool _validateForm() {
    bool valid = true;
    String? titleErr;
    String? bodyErr;
    String? scheduleErr;

    if (state.draft.title.trim().isEmpty) {
      titleErr = 'Title is required';
      valid = false;
    } else if (state.draft.title.length > 200) {
      titleErr = 'Title must be 200 characters or less';
      valid = false;
    }

    if (state.draft.body.trim().isEmpty) {
      bodyErr = 'Body is required';
      valid = false;
    } else if (state.draft.body.length > 1000) {
      bodyErr = 'Body must be 1000 characters or less';
      valid = false;
    }

    if (state.draft.scheduleType == ScheduleType.weekly &&
        (state.draft.weekdays == null || state.draft.weekdays!.isEmpty)) {
      scheduleErr = 'Select at least one weekday';
      valid = false;
    }

    if (state.draft.scheduleType == ScheduleType.interval &&
        (state.draft.intervalMinutes == null ||
            state.draft.intervalMinutes! <= 0)) {
      scheduleErr = 'Interval must be greater than 0';
      valid = false;
    }

    state = CreateNotificationState(
      draft: state.draft,
      isEditing: state.isEditing,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      titleError: titleErr,
      bodyError: bodyErr,
      scheduleError: scheduleErr,
    );

    return valid;
  }

  /// Save the notification (create or update).
  ///
  /// Returns true on success so the UI can pop the screen.
  /// On failure, sets [errorMessage] on the state.
  Future<bool> save() async {
    if (!_validateForm()) return false;

    state = state.copyWith(isSaving: true, clearErrorMessage: true);

    try {
      // Ensure updatedAt is current on final save.
      final finalItem = state.draft.copyWith(updatedAt: DateTime.now().toUtc());

      if (state.isEditing) {
        await _service.updateNotification(finalItem);
      } else {
        await _service.createNotification(finalItem);
      }

      state = state.copyWith(isSaving: false);
      return true;
    } on NotificationLimitException catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.message);
      return false;
    } on NotificationValidationException catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save notification. Please try again.',
      );
      return false;
    }
  }
}

/// Provider for the create/edit notification form.
///
/// Usage:
/// - Create mode: just read the provider, it starts with a blank draft.
/// - Edit mode: after reading, call `notifier.loadForEdit(id)`.
final createNotificationProvider = StateNotifierProvider.autoDispose<
    CreateNotificationNotifier, CreateNotificationState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return CreateNotificationNotifier(service);
});
