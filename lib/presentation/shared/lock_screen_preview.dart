import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:custom_notify/core/constants/app_colors.dart';
import 'package:custom_notify/core/constants/app_sizes.dart';

/// Realistic iOS-style lock-screen notification preview.
///
/// Shows a frosted-glass notification card on a dark wallpaper background,
/// mimicking how the notification will appear on the user's lock screen.
/// Updates live as the user types in the Create/Edit form.
///
/// Layout (matches iOS 17 notification style):
/// ┌─────────────────────────────────────────┐
/// │  [icon] CUSTOMNOTIFY            now     │
/// │  Title (bold)                           │
/// │  Body text (regular, up to 4 lines)     │
/// └─────────────────────────────────────────┘
class LockScreenPreview extends StatelessWidget {
  const LockScreenPreview({
    super.key,
    required this.title,
    required this.body,
  });

  /// Notification title — shows placeholder when empty.
  final String title;

  /// Notification body — shows placeholder when empty.
  final String body;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title.isNotEmpty ? title : 'Your notification title';
    final displayBody =
        body.isNotEmpty ? body : 'Your notification message will appear here';
    final isEmpty = title.isEmpty && body.isEmpty;

    return Container(
      // Dark wallpaper-style background to simulate lock screen.
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingMd,
        AppSizes.spacingLg,
        AppSizes.spacingMd,
        AppSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        // Dark gradient simulating an iOS wallpaper.
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1C2E),
            Color(0xFF2A2D45),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        children: [
          // Lock screen time display (cosmetic, adds realism).
          _LockScreenTime(),
          const SizedBox(height: AppSizes.spacingMd),

          // The notification card itself.
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.spacingMd),
                decoration: BoxDecoration(
                  // Frosted glass effect — translucent white over blur.
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App header row: icon + app name + timestamp.
                    _NotificationHeader(isEmpty: isEmpty),
                    const SizedBox(height: 6),

                    // Title.
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isEmpty
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.white,
                        height: 1.3,
                      ),
                      child: Text(
                        displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Body.
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isEmpty
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                      child: Text(
                        displayBody,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// App header row mimicking iOS notification style:
/// [small app icon]  CUSTOMNOTIFY           now
class _NotificationHeader extends StatelessWidget {
  const _NotificationHeader({required this.isEmpty});

  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Small app icon (gold circle with bell).
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Icon(
            Icons.notifications,
            size: 13,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 6),

        // App name.
        Text(
          'CUSTOMNOTIFY',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.5),
            letterSpacing: 0.3,
          ),
        ),
        const Spacer(),

        // Timestamp.
        Text(
          'now',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

/// Cosmetic lock-screen time display for realism.
/// Shows the current time in large text like an iOS lock screen.
class _LockScreenTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');

    return Text(
      '$hour:$minute',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w200,
        color: Colors.white.withValues(alpha: 0.85),
        letterSpacing: 2,
      ),
    );
  }
}
