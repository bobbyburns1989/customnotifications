import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/template_item.dart';
import '../../domain/services/template_service.dart';

/// Provides the template service singleton.
final templateServiceProvider = Provider<TemplateService>((ref) {
  return TemplateService.instance;
});

/// Loads and provides all built-in templates.
///
/// Triggers the one-time JSON asset load on first access.
/// Returns an empty list while loading.
final templateListProvider = FutureProvider<List<TemplateItem>>((ref) async {
  final service = ref.watch(templateServiceProvider);
  await service.loadTemplates();
  return service.getAll();
});

/// Provides the list of unique template categories.
final templateCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(templateServiceProvider);
  await service.loadTemplates();
  return service.getCategories();
});
