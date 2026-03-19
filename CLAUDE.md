# CustomNotifications — AI Development Guide

## TL;DR

| Key | Value |
|-----|-------|
| **App** | CustomNotifications — "Your Alerts, Your Way" |
| **Version** | 1.0.0+1 |
| **Bundle ID** | `com.customnotificationsapp.app` |
| **Stack** | Flutter 3.x + Riverpod + Drift (SQLite) + Freezed + GoRouter + flutter_local_notifications |
| **Model** | Freemium $0.99/month via RevenueCat, 3-day trial |
| **Free Tier** | 10 active notifications, basic scheduling, 10 templates, basic history |
| **Premium** | Unlimited notifications, all schedule types, persistence/nagging, analytics, all templates, backup/restore |
| **Contact** | bobby@customapps.us |

## Quick Commands

```bash
# Run
flutter run                    # Debug on connected device
flutter run --release          # Release mode

# Build
flutter build ios --release
flutter build appbundle --release

# Code generation (Drift + Freezed)
dart run build_runner build --delete-conflicting-outputs

# Quality
flutter analyze                # Must show 0 issues before commits
flutter test                   # Run all tests

# Clean rebuild
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

## Architecture

4-layer architecture with Riverpod for state management:

```
lib/
├── core/          # Constants, theme, routing, extensions, utils
├── data/          # Database (Drift tables, DAOs), services (plugin wrappers)
├── domain/        # Models (Freezed), business logic services
├── presentation/  # Providers, screens, shared widgets
└── generated/     # build_runner output
```

**Data flow:** Screen → Provider → Domain Service → Data Repository/DAO → Drift DB

## Code Standards

### Must Follow
- `withValues()` NOT `withOpacity()` (deprecated)
- Check `mounted` before `setState` in async operations
- `Logger.info()` for logging (auto-disabled in production)
- Theme properties only — never hardcode colors
- `flutter analyze` must pass with 0 issues before any commit
- All models use Freezed with code-gen (@freezed, copyWith, toJson/fromJson)
- All database operations use Drift typed queries — no raw SQL

### Never Do
- **Never use `awesome_notifications`** — incompatible with flutter_local_notifications
- **Never use Hive or Isar** — both abandoned, use Drift (SQLite ORM)
- **Never use Firebase or any cloud database** — only network call is RevenueCat
- **Never schedule raw DateTime** — always use TZDateTime from timezone package
- **Never exceed 60 pending iOS notifications** — use rolling window scheduler (4 buffer slots)
- **Never hardcode RevenueCat product IDs** — configure in RevenueCat dashboard

## Critical Constraints

### iOS 64 Pending Notification Limit
iOS silently drops the oldest notification when you schedule the 65th. No error, no warning.
**Solution:** Rolling window scheduler in `schedule_service.dart`:
1. Calculate next 60 fire times across ALL active schedules
2. Cancel all pending iOS notifications
3. Schedule only the next 60 (leave 4 buffer slots)
4. Re-sync on every CRUD operation, app foreground, and via WorkManager

### Android Battery Optimization
Samsung, Xiaomi, Huawei, OnePlus all aggressively kill background apps.
No programmatic fix — must detect manufacturer and guide user to whitelist the app.
Reference: dontkillmyapp.com

### Notification IDs
flutter_local_notifications requires int IDs. Generate stable, deterministic IDs
by hashing (notificationUUID + fireTime). Avoid collisions.

## Freemium Rules

| Feature | Free | Premium |
|---------|------|---------|
| Active notifications | 10 | Unlimited |
| Schedule types | One-time, Daily, Weekly | All (+ Interval, Random, Custom) |
| Templates | 10 built-in | All 50+ built-in + custom |
| Persistence/Nagging | No | Yes |
| Escalation | No | Yes |
| Analytics dashboard | No | Yes |
| Custom snooze options | No | Yes |
| Backup/Restore | No | Yes |
| History log | Yes | Yes |

## Design System

- **Light mode only** (dark mode deferred)
- **Gold accent**: #FFD700 (primary), #FFE44D (light), #B8860B (dark/pressed)
- **Font**: Inter (bundled in assets/fonts/inter/)
- **Card radius**: 14px
- **Button height**: 48px
- **Bottom nav**: 4 tabs — Home, Create, History, Settings

## Key File Locations

| Task | File |
|------|------|
| Database tables | `lib/data/database/tables/` |
| Database definition | `lib/data/database/app_database.dart` |
| Notification scheduling | `lib/domain/services/schedule_service.dart` |
| Plugin wrapper | `lib/data/services/notification_plugin_service.dart` |
| RevenueCat | `lib/data/services/revenuecat_service.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Routes | `lib/core/routing/app_router.dart` |
| Colors | `lib/core/constants/app_colors.dart` |
| Providers | `lib/presentation/providers/` |

## Haptic Patterns

- `HapticFeedback.heavyImpact()` — notification created/deleted, errors
- `HapticFeedback.mediumImpact()` — toggle on/off, confirmations
- `HapticFeedback.lightImpact()` — navigation taps, minor interactions
