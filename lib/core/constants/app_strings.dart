/// App-wide string constants.
///
/// Centralizes user-facing labels so they are easy to find
/// and update (or eventually localize).
class AppStrings {
  AppStrings._();

  static const String appName = 'CustomNotify';
  static const String appTagline = 'Your Alerts, Your Way';

  // Bottom nav tab labels
  static const String tabHome = 'Home';
  static const String tabCreate = 'Create';
  static const String tabTemplates = 'Templates';
  static const String tabHistory = 'History';
  static const String tabSettings = 'Settings';

  // Error messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String failedToLoadTemplates = 'Failed to load templates';

  // Empty states
  static const String emptyNotifications = 'No notifications yet';
  static const String emptyNotificationsHint =
      'Tap the button below to create your first notification.';
  static const String emptyHistory = 'No history yet';
  static const String emptyHistoryHint =
      'Delivered and tapped notifications will appear here.';
  static const String emptyTemplates = 'No templates available';

  // Notification card
  static const String overdue = 'Overdue';

  // Create screen hints
  static const String titleHint = 'e.g. Take medication';
  static const String bodyHint = 'e.g. Time to take your daily vitamins!';

  // Settings
  static const String permissionsGranted = 'Notification permissions granted';
  static const String permissionsDenied =
      'Permissions denied - enable in system Settings';

  // Accessibility
  static const String createNotificationTooltip = 'Create notification';
  static const String premiumFeature = 'Premium feature';

  // Feedback messages
  static const String notificationCreated = 'Notification created!';
  static const String changesSaved = 'Changes saved!';
  static const String notificationDeleted = 'Notification deleted';
  static const String notificationActive = 'Active';
  static const String notificationPaused = 'Paused';
  static const String welcomeToPremium = 'Welcome to Premium!';
  static const String premiumRestored = 'Premium restored!';
  static const String noPreviousPurchase = 'No previous purchase found';
  static const String purchaseFailed = 'Something went wrong. Please try again.';
}
