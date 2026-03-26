import 'package:custom_notify/core/utils/logger.dart';
import 'package:custom_notify/data/database/daos/notification_dao.dart';
import 'package:custom_notify/data/database/mappers/notification_mapper.dart';
import 'package:custom_notify/data/services/notification_plugin_service.dart';
import 'package:custom_notify/domain/models/notification_item.dart';
import 'package:custom_notify/domain/services/schedule_service.dart';

/// Business logic layer for notification CRUD operations.
///
/// Sits between providers and the DAO. Handles validation,
/// free tier limit enforcement, and delegates persistence to
/// [NotificationDao]. After each mutation, triggers a re-sync
/// of OS-level scheduled notifications via [ScheduleService].
class NotificationService {
  NotificationService(
    this._dao,
    this._scheduleService,
    this._pluginService, {
    this.isPremium = false,
  });

  final NotificationDao _dao;
  final ScheduleService _scheduleService;
  final NotificationPluginService _pluginService;

  /// Whether the current user has an active premium subscription.
  /// When true, free tier limits are bypassed.
  final bool isPremium;

  /// Maximum active notifications allowed on the free tier.
  static const int freeTierLimit = 10;

  /// Create a new notification after validating and checking the free tier cap.
  ///
  /// Throws [NotificationLimitException] if the user has reached the free tier
  /// limit and is not a premium subscriber.
  /// Throws [NotificationValidationException] for invalid fields.
  Future<void> createNotification(NotificationItem item) async {
    _validate(item);

    if (!isPremium) {
      final activeCount = await _dao.countActive();
      if (activeCount >= freeTierLimit) {
        throw NotificationLimitException(
          'You can have up to $freeTierLimit active notifications. '
          'Upgrade to Premium for unlimited.',
        );
      }
    }

    await _dao.insertItem(item.toCompanion());
    Logger.info('Created notification: ${item.id}', tag: 'NotificationService');

    // Ensure notification permissions are granted. Fire-and-forget —
    // the OS dialog will appear if needed, and scheduling proceeds
    // regardless (notifications just won't show until granted).
    _pluginService.requestPermissions();

    await _scheduleService.syncAll();
  }

  /// Update an existing notification.
  ///
  /// Throws [NotificationValidationException] for invalid fields.
  Future<void> updateNotification(NotificationItem item) async {
    _validate(item);
    await _dao.updateItem(item.toCompanion());
    Logger.info('Updated notification: ${item.id}', tag: 'NotificationService');
    await _scheduleService.syncAll();
  }

  /// Delete a notification by ID.
  Future<void> deleteNotification(String id) async {
    await _dao.deleteItem(id);
    Logger.info('Deleted notification: $id', tag: 'NotificationService');
    await _scheduleService.syncAll();
  }

  /// Toggle a notification's active state.
  ///
  /// When re-enabling, checks the free tier limit first.
  /// Throws [NotificationLimitException] if the limit would be exceeded.
  Future<void> toggleActive(String id, {required bool isActive}) async {
    if (isActive && !isPremium) {
      final activeCount = await _dao.countActive();
      if (activeCount >= freeTierLimit) {
        throw NotificationLimitException(
          'You can have up to $freeTierLimit active notifications. '
          'Upgrade to Premium for unlimited.',
        );
      }
    }

    await _dao.toggleActive(id, isActive: isActive);
    Logger.info(
      'Toggled notification $id → ${isActive ? "active" : "inactive"}',
      tag: 'NotificationService',
    );
    await _scheduleService.syncAll();
  }

  /// Fetch a single notification by ID, or null if not found.
  Future<NotificationItem?> getById(String id) async {
    final entity = await _dao.getById(id);
    return entity?.toDomain();
  }

  /// Validates required fields on a notification.
  void _validate(NotificationItem item) {
    if (item.title.trim().isEmpty) {
      throw NotificationValidationException('Title is required.');
    }
    if (item.body.trim().isEmpty) {
      throw NotificationValidationException('Body is required.');
    }
    if (item.title.length > 200) {
      throw NotificationValidationException(
        'Title must be 200 characters or less.',
      );
    }
    if (item.body.length > 1000) {
      throw NotificationValidationException(
        'Body must be 1000 characters or less.',
      );
    }
    // For weekly schedules, weekdays must not be empty.
    if (item.scheduleType.name == 'weekly' &&
        (item.weekdays == null || item.weekdays!.isEmpty)) {
      throw NotificationValidationException(
        'Select at least one weekday for weekly notifications.',
      );
    }
    // For interval schedules, interval must be positive.
    if (item.scheduleType.name == 'interval' &&
        (item.intervalMinutes == null || item.intervalMinutes! <= 0)) {
      throw NotificationValidationException(
        'Interval must be greater than 0 minutes.',
      );
    }
  }
}

/// Thrown when the free tier notification limit is reached.
class NotificationLimitException implements Exception {
  NotificationLimitException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Thrown when notification fields fail validation.
class NotificationValidationException implements Exception {
  NotificationValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}
