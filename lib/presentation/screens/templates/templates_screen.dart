import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/domain/models/template_item.dart';
import 'package:custom_notify/presentation/providers/premium_provider.dart';
import 'package:custom_notify/presentation/providers/template_provider.dart';

/// Template gallery screen with horizontal category filter chips.
///
/// Tapping a free template navigates to the Create screen with fields
/// pre-filled. Tapping a premium template opens the paywall.
/// Free templates are sorted to the top so users see actionable content first.
class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredTemplatesProvider);
    final categoriesAsync = ref.watch(templateCategoriesProvider);
    final selectedCategory = ref.watch(selectedTemplateCategoryProvider);
    final isPremium = ref.watch(premiumStatusProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      body: Column(
        children: [
          // ── Category filter chips ──
          categoriesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (categories) {
              // Compute per-category counts from the full (unfiltered) list.
              final allTemplates =
                  ref.watch(templateListProvider).valueOrNull ?? [];
              final counts = <String, int>{};
              for (final t in allTemplates) {
                counts[t.category] = (counts[t.category] ?? 0) + 1;
              }
              return _CategoryChipBar(
                categories: categories,
                categoryCounts: counts,
                totalCount: allTemplates.length,
                selected: selectedCategory,
                onSelected: (category) {
                  HapticFeedback.lightImpact();
                  ref.read(selectedTemplateCategoryProvider.notifier).state =
                      category;
                },
              );
            },
          ),

          // ── Template list ──
          Expanded(
            child: filteredAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  AppStrings.failedToLoadTemplates,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              data: (templates) {
                if (templates.isEmpty) {
                  return const Center(child: Text(AppStrings.emptyTemplates));
                }

                // When a specific category is selected, show a flat list
                // (no section headers — the chip already communicates context).
                if (selectedCategory != null) {
                  return _TemplateList(
                    templates: templates,
                    isPremium: isPremium,
                    onTap: (t) => _onTemplateTap(context, ref, t, isPremium),
                  );
                }

                // When "All" is selected, group by category with headers.
                // Show 3 templates per category with "See all" to keep
                // the overview scannable.
                final categories =
                    categoriesAsync.valueOrNull ?? [];
                return _GroupedTemplateList(
                  categories: categories,
                  templates: templates,
                  isPremium: isPremium,
                  onTap: (t) => _onTemplateTap(context, ref, t, isPremium),
                  onSeeAll: (category) {
                    HapticFeedback.lightImpact();
                    ref.read(selectedTemplateCategoryProvider.notifier).state =
                        category;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onTemplateTap(
    BuildContext context,
    WidgetRef ref,
    TemplateItem template,
    bool isPremium,
  ) {
    HapticFeedback.lightImpact();

    // Premium-gated template: open paywall.
    if (template.isPremium && !isPremium) {
      context.push(AppRoutes.premium);
      return;
    }

    // Navigate to the Create screen with template data.
    context.push(
      '${AppRoutes.create}/template/${template.id}',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category chip bar
// ─────────────────────────────────────────────────────────────────────────────

/// Horizontal scrollable row of filter chips — "All" + one per category.
/// Each chip shows a count badge so users can gauge category size at a glance.
class _CategoryChipBar extends StatelessWidget {
  const _CategoryChipBar({
    required this.categories,
    required this.categoryCounts,
    required this.totalCount,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final Map<String, int> categoryCounts;
  final int totalCount;
  final String? selected;
  final ValueChanged<String?> onSelected;

  /// Maps each category name to a representative icon for visual scanning.
  static const _categoryIcons = <String, IconData>{
    'Health': Icons.favorite_border,
    'Work': Icons.work_outline,
    'Personal': Icons.person_outline,
    'Fitness': Icons.fitness_center,
    'Custom': Icons.tune,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingSm,
      ),
      child: Row(
        children: [
          // "All" chip
          _Chip(
            label: 'All',
            icon: Icons.grid_view_rounded,
            count: totalCount,
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSizes.spacingSm),
          // One chip per category
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.spacingSm),
                child: _Chip(
                  label: cat,
                  icon: _categoryIcons[cat] ?? Icons.label_outline,
                  count: categoryCounts[cat] ?? 0,
                  isSelected: selected == cat,
                  onTap: () => onSelected(cat),
                ),
              )),
        ],
      ),
    );
  }
}

/// A single filter chip with icon, count badge, and gold fill when selected.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withValues(alpha: 0.15)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSizeXs,
              color: isSelected ? AppColors.goldDark : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spacingSm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppColors.goldDark
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
            // Count badge
            if (count != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.goldDark.withValues(alpha: 0.15)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.goldDark
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Template lists
// ─────────────────────────────────────────────────────────────────────────────

/// Flat template list (used when a single category is selected).
class _TemplateList extends StatelessWidget {
  const _TemplateList({
    required this.templates,
    required this.isPremium,
    required this.onTap,
  });

  final List<TemplateItem> templates;
  final bool isPremium;
  final void Function(TemplateItem) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingSm,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
        child: _TemplateCard(
          template: templates[index],
          isLocked: templates[index].isPremium && !isPremium,
          onTap: () => onTap(templates[index]),
        ),
      ),
    );
  }
}

/// Grouped template list with category section headers (used for "All").
/// Shows up to [_maxPreview] templates per category, with a "See all" button
/// that switches the filter chip to that category.
/// Free templates are shown first within each category.
class _GroupedTemplateList extends StatelessWidget {
  const _GroupedTemplateList({
    required this.categories,
    required this.templates,
    required this.isPremium,
    required this.onTap,
    required this.onSeeAll,
  });

  /// Max templates shown per category in the "All" overview.
  static const _maxPreview = 3;

  final List<String> categories;
  final List<TemplateItem> templates;
  final bool isPremium;
  final void Function(TemplateItem) onTap;
  final void Function(String category) onSeeAll;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        // Get templates for this category, with free first.
        final catTemplates =
            templates.where((t) => t.category == category).toList();
        final free = catTemplates.where((t) => !t.isPremium).toList();
        final premium = catTemplates.where((t) => t.isPremium).toList();
        final sorted = [...free, ...premium];

        // Only show a preview in the "All" view.
        final preview = sorted.take(_maxPreview).toList();
        final hasMore = sorted.length > _maxPreview;

        return _CategorySection(
          category: category,
          templates: preview,
          totalCount: sorted.length,
          hasMore: hasMore,
          isPremium: isPremium,
          onTemplateTap: onTap,
          onSeeAll: () => onSeeAll(category),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category section (for "All" view)
// ─────────────────────────────────────────────────────────────────────────────

/// A section header + list of template cards for one category.
/// Shows a "See all" row when there are more templates than displayed.
class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.templates,
    required this.totalCount,
    required this.hasMore,
    required this.isPremium,
    required this.onTemplateTap,
    required this.onSeeAll,
  });

  final String category;
  final List<TemplateItem> templates;
  final int totalCount;
  final bool hasMore;
  final bool isPremium;
  final void Function(TemplateItem) onTemplateTap;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header with count
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.spacingSm,
            top: AppSizes.spacingSm,
          ),
          child: Row(
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              Text(
                '($totalCount)',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),

        // Template cards (preview subset)
        ...templates.map((template) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
              child: _TemplateCard(
                template: template,
                isLocked: template.isPremium && !isPremium,
                onTap: () => onTemplateTap(template),
              ),
            )),

        // "See all" button — switches the chip filter to this category.
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
            child: Center(
              child: TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all $totalCount',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),

        const SizedBox(height: AppSizes.spacingSm),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Template card
// ─────────────────────────────────────────────────────────────────────────────

/// A single template card showing icon, title, schedule badge, and lock.
class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.isLocked,
    required this.onTap,
  });

  final TemplateItem template;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMd,
            vertical: AppSizes.spacingSm,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppColors.surfaceVariant
                      : AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _resolveIcon(template.iconName),
                  size: 20,
                  color: isLocked ? AppColors.textTertiary : AppColors.goldDark,
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),

              // Title + body preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLocked
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spacingXxs),
                    Text(
                      template.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              // Schedule type badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingSm,
                    vertical: AppSizes.spacingXxs),
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppColors.surfaceVariant
                      : AppColors.goldLight.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  template.scheduleType.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isLocked
                            ? AppColors.textTertiary
                            : AppColors.goldDark,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),

              // Lock icon for premium templates
              if (isLocked) ...[
                const SizedBox(width: AppSizes.spacingXs),
                const Tooltip(
                  message: AppStrings.premiumFeature,
                  child: Icon(
                    Icons.lock_outline,
                    size: AppSizes.iconSizeXs,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Resolve a Material icon name string to an IconData.
  ///
  /// Maps the icon names used in the JSON template file to their
  /// corresponding Material Icons constants.
  static IconData _resolveIcon(String name) {
    const map = <String, IconData>{
      'medication': Icons.medication,
      'water_drop': Icons.water_drop,
      'self_improvement': Icons.self_improvement,
      'local_pharmacy': Icons.local_pharmacy,
      'visibility': Icons.visibility,
      'bedtime': Icons.bedtime,
      'accessibility_new': Icons.accessibility_new,
      'air': Icons.air,
      'restaurant': Icons.restaurant,
      'mood': Icons.mood,
      'groups': Icons.groups,
      'summarize': Icons.summarize,
      'timer': Icons.timer,
      'free_breakfast': Icons.free_breakfast,
      'do_not_disturb_on': Icons.do_not_disturb_on,
      'email': Icons.email,
      'person': Icons.person,
      'rate_review': Icons.rate_review,
      'lunch_dining': Icons.lunch_dining,
      'checklist': Icons.checklist,
      'local_laundry_service': Icons.local_laundry_service,
      'shopping_cart': Icons.shopping_cart,
      'payments': Icons.payments,
      'yard': Icons.yard,
      'pets': Icons.pets,
      'edit_note': Icons.edit_note,
      'menu_book': Icons.menu_book,
      'cleaning_services': Icons.cleaning_services,
      'call': Icons.call,
      'favorite': Icons.favorite,
      'fitness_center': Icons.fitness_center,
      'directions_run': Icons.directions_run,
      'directions_walk': Icons.directions_walk,
      'blender': Icons.blender,
      'weekend': Icons.weekend,
      'monitor_weight': Icons.monitor_weight,
      'restaurant_menu': Icons.restaurant_menu,
      'cake': Icons.cake,
      'celebration': Icons.celebration,
      'delete': Icons.delete_outline,
      'directions_car': Icons.directions_car,
      'home': Icons.home,
      'autorenew': Icons.autorenew,
      'school': Icons.school,
      'grass': Icons.grass,
      'mail': Icons.mail,
    };
    return map[name] ?? Icons.notifications_outlined;
  }
}
