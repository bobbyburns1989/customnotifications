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

/// Tracks which category filter chip is selected on the templates screen.
/// null = "All" categories shown.
final selectedTemplateCategoryProvider = StateProvider<String?>((ref) => null);

/// Provides templates filtered by the selected category, with free
/// templates sorted first within each category so users see actionable
/// content before premium-locked items.
final filteredTemplatesProvider = Provider<AsyncValue<List<TemplateItem>>>((ref) {
  final templatesAsync = ref.watch(templateListProvider);
  final selectedCategory = ref.watch(selectedTemplateCategoryProvider);

  return templatesAsync.whenData((templates) {
    // Filter by category if one is selected.
    final filtered = selectedCategory == null
        ? templates
        : templates.where((t) => t.category == selectedCategory).toList();

    // Sort: free templates first, then premium, preserving original order
    // within each group.
    final free = filtered.where((t) => !t.isPremium).toList();
    final premium = filtered.where((t) => t.isPremium).toList();
    return [...free, ...premium];
  });
});
