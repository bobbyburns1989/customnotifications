import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/mappers/history_mapper.dart';
import '../../domain/models/history_entry.dart';
import 'database_provider.dart';

/// Streams recent history entries from the database, mapped to domain models.
///
/// Entries are sorted newest-first, capped at 200 rows to avoid
/// loading the entire history table into memory.
final historyListProvider =
    StreamProvider.autoDispose<List<HistoryEntry>>((ref) {
  final dao = ref.watch(historyDaoProvider);
  return dao.watchAll().map(
        (entities) => entities.map((e) => e.toDomain()).toList(),
      );
});
