import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/mappers/notification_mapper.dart';
import '../../domain/models/notification_item.dart';
import 'database_provider.dart';

/// Streams all notifications from the database, mapped to domain models.
///
/// The list is sorted by createdAt descending (newest first), matching
/// the query in [NotificationDao.watchAll()].
final notificationListProvider =
    StreamProvider.autoDispose<List<NotificationItem>>((ref) {
  final dao = ref.watch(notificationDaoProvider);
  return dao.watchAll().map(
        (entities) => entities.map((e) => e.toDomain()).toList(),
      );
});
