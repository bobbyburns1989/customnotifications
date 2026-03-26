import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/domain/models/template_item.dart';
import 'package:custom_notify/presentation/providers/premium_provider.dart';
import 'package:custom_notify/presentation/providers/template_provider.dart';

/// Template gallery screen — grouped by category.
///
/// Tapping a free template navigates to the Create screen with fields
/// pre-filled. Tapping a premium template opens the paywall.
class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templateListProvider);
    final categoriesAsync = ref.watch(templateCategoriesProvider);
    final isPremium = ref.watch(premiumStatusProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Failed to load templates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        data: (templates) {
          final categories = categoriesAsync.valueOrNull ?? [];
          if (templates.isEmpty) {
            return const Center(child: Text('No templates available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.spacingMd),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryTemplates = templates
                  .where((t) => t.category == category)
                  .toList();

              return _CategorySection(
                category: category,
                templates: categoryTemplates,
                isPremium: isPremium,
                onTemplateTap: (template) =>
                    _onTemplateTap(context, ref, template, isPremium),
              );
            },
          );
        },
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

    // Navigate to the Create screen with template data as query params.
    // The Create screen reads these to pre-fill the form.
    context.push(
      '${AppRoutes.create}/template/${template.id}',
    );
  }
}

/// A section header + grid of template cards for one category.
class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.templates,
    required this.isPremium,
    required this.onTemplateTap,
  });

  final String category;
  final List<TemplateItem> templates;
  final bool isPremium;
  final void Function(TemplateItem) onTemplateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.spacingSm,
            top: AppSizes.spacingSm,
          ),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        ...templates.map((template) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingSm),
              child: _TemplateCard(
                template: template,
                isLocked: template.isPremium && !isPremium,
                onTap: () => onTemplateTap(template),
              ),
            )),
        const SizedBox(height: AppSizes.spacingSm),
      ],
    );
  }
}

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
                    const SizedBox(height: 2),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppColors.surfaceVariant
                      : AppColors.goldLight.withValues(alpha: 0.5),
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
                const Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: AppColors.textTertiary,
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
