/// Actions that can be recorded in notification history.
enum HistoryAction {
  delivered,
  tapped,
  dismissed,
  snoozed;

  /// Human-readable label for display in the UI.
  String get label => switch (this) {
        HistoryAction.delivered => 'Delivered',
        HistoryAction.tapped => 'Tapped',
        HistoryAction.dismissed => 'Dismissed',
        HistoryAction.snoozed => 'Snoozed',
      };
}
