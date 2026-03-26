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
