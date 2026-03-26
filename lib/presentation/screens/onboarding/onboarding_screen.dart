import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';
import 'package:custom_notify/core/constants/app_strings.dart';
import 'package:custom_notify/core/routing/app_router.dart';
import 'package:custom_notify/data/services/notification_plugin_service.dart';
import 'package:custom_notify/presentation/providers/onboarding_provider.dart';

/// 3-page onboarding flow shown on first launch.
///
/// Page 1: Welcome — branding + tagline
/// Page 2: How It Works — 3-step explanation
/// Page 3: Permissions — notification permission request
///
/// After completion, sets a SharedPreferences flag so onboarding
/// is never shown again, then navigates to the home screen.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    HapticFeedback.mediumImpact();
    await completeOnboarding(ref);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _requestPermissionsAndFinish() async {
    HapticFeedback.mediumImpact();
    await NotificationPluginService.instance.requestPermissions();
    await _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _WelcomePage(onNext: () => _goToPage(1)),
                  _HowItWorksPage(onNext: () => _goToPage(2)),
                  _PermissionsPage(
                    onAllow: _requestPermissionsAndFinish,
                    onSkip: _finishOnboarding,
                  ),
                ],
              ),
            ),

            // Page dots indicator
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingXl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.gold : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1: Welcome
// ---------------------------------------------------------------------------

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon placeholder — gold circle with bell icon.
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              size: 48,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSizes.spacingXl),
          ElevatedButton(
            onPressed: onNext,
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2: How It Works
// ---------------------------------------------------------------------------

class _HowItWorksPage extends StatelessWidget {
  const _HowItWorksPage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.spacingXl),
          const _StepRow(
            icon: Icons.edit_outlined,
            number: '1',
            title: 'Create',
            description: 'Write your notification title and message',
          ),
          const SizedBox(height: AppSizes.spacingLg),
          const _StepRow(
            icon: Icons.schedule_outlined,
            number: '2',
            title: 'Schedule',
            description: 'Choose when and how often to be reminded',
          ),
          const SizedBox(height: AppSizes.spacingLg),
          const _StepRow(
            icon: Icons.notifications_active_outlined,
            number: '3',
            title: 'Receive',
            description: 'Get notified right on time, every time',
          ),
          const SizedBox(height: AppSizes.spacingXl),
          ElevatedButton(
            onPressed: onNext,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.icon,
    required this.number,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Step number circle
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.goldDark, size: 22),
        ),
        const SizedBox(width: AppSizes.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3: Permissions
// ---------------------------------------------------------------------------

class _PermissionsPage extends StatelessWidget {
  const _PermissionsPage({
    required this.onAllow,
    required this.onSkip,
  });

  final VoidCallback onAllow;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          Text(
            'Stay on Track',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            'Enable notifications so your reminders\ncan reach you on time.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSizes.spacingXl),
          ElevatedButton(
            onPressed: onAllow,
            child: const Text('Allow Notifications'),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Skip for now',
              style: TextStyle(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
