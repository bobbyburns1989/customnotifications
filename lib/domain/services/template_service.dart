import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/utils/logger.dart';
import '../models/template_item.dart';

/// Loads and provides access to built-in notification templates.
///
/// Templates are bundled as a JSON asset and loaded once at startup.
/// No database table needed — templates are read-only for MVP.
class TemplateService {
  TemplateService._();

  static final TemplateService instance = TemplateService._();

  List<TemplateItem> _templates = [];
  bool _loaded = false;

  /// Load templates from the bundled JSON asset.
  ///
  /// Safe to call multiple times — returns immediately if already loaded.
  Future<void> loadTemplates() async {
    if (_loaded) return;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/templates/built_in_templates.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _templates = jsonList
          .map((e) => TemplateItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _loaded = true;
      Logger.info(
        'Loaded ${_templates.length} templates',
        tag: 'TemplateService',
      );
    } catch (e) {
      Logger.info('Failed to load templates: $e', tag: 'TemplateService');
      _templates = [];
    }
  }

  /// All templates (free and premium).
  List<TemplateItem> getAll() => List.unmodifiable(_templates);

  /// Templates filtered by category.
  List<TemplateItem> getByCategory(String category) {
    return _templates.where((t) => t.category == category).toList();
  }

  /// All unique category names in display order.
  List<String> getCategories() {
    final seen = <String>{};
    final categories = <String>[];
    for (final t in _templates) {
      if (seen.add(t.category)) {
        categories.add(t.category);
      }
    }
    return categories;
  }

  /// Fetch a single template by ID.
  TemplateItem? getById(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
