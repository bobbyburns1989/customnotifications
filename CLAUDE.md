# CustomNotify — AI Development Guide

## TL;DR

| Key | Value |
|-----|-------|
| **App** | CustomNotify — "Your Alerts, Your Way" |
| **Version** | 1.0.0+1 |
| **Bundle ID** | `com.customnotifications.app` (iOS + Android) |
| **Dart package** | `custom_notify` (imports: `package:custom_notify/...`) |
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

# Regenerate app icons (after changing assets/icons/app_icon.png)
dart run flutter_launcher_icons

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
├── data/          # Database (Drift tables, DAOs), repositories, services
├── domain/        # Models (Freezed), enums, business logic services
├── presentation/  # Providers, screens, shared widgets
└── main.dart
```

Generated files (`.freezed.dart`, `.g.dart`) live alongside their source files.

**Data flow:** Screen → Provider → Domain Service → Data Repository/DAO → Drift DB

## Development Status

### Phase 1 — Core CRUD + Scheduling (complete)
- [x] Project scaffolding (theme, routing, bottom nav)
- [x] Database layer (Drift tables, DAOs, mappers)
- [x] Domain models (Freezed: NotificationItem, HistoryEntry, enums)
- [x] NotificationService (CRUD + validation + free tier limits)
- [x] NotificationPluginService (flutter_local_notifications OS bridge)
- [x] ScheduleService (rolling window scheduler, iOS 60-slot budget)
- [x] HistoryService (records notification tap events)
- [x] Riverpod providers (database, plugin, schedule, history, notification list, create form)
- [x] Home screen (notification list with toggle/swipe-delete/FAB)
- [x] Create/Edit screen (full form with schedule type picker, date/time/weekday pickers)
- [x] History screen (grouped by date, action icons/badges, empty state)
- [x] Settings screen (permissions, pending count, history pruning, about)
- [x] Platform permissions (Info.plist background modes, AndroidManifest permissions + receivers)
- [x] Notification tap → history recording wired in main.dart

### Phase 2 — Background & Lifecycle (complete)
- [x] WorkManager periodic schedule re-sync (30-min interval)
- [x] App lifecycle foreground re-sync (AppLifecycleListener in main.dart)
- [x] Onboarding flow with permission request (3-page PageView)
- [x] Undo delete with 5-second snackbar action

### Phase 3 — Premium & Polish (v1 complete)
- [x] RevenueCat service (purchases_flutter wrapper, placeholder API keys)
- [x] Custom paywall screen (branded, feature comparison, purchase/restore)
- [x] Premium gate (NotificationService bypasses limits for premium users)
- [x] Premium schedule type validation at service layer (defense-in-depth)
- [x] Templates system (50 built-in templates, JSON asset, gallery screen)
- [x] Page transition animations (slide-up overlays, fade onboarding)
- [x] Confirmation & success feedback (snackbars for edit/toggle/purchase failure)
- [x] Floating rounded snackbar theme
- [x] Feedback strings centralized in AppStrings
- [x] App icon & branding (CustomNotify logo across all platforms via flutter_launcher_icons)
- [x] Unit tests: NotificationService (18 tests), ScheduleService (8 tests), HistoryService (5 tests)
- [x] Widget test: Bottom nav tab labels
- [x] Lock-screen preview in Create/Edit screen (iOS-style, live updates as user types)

### Post-launch (deferred)
- [ ] Random schedule type (fire time computation)
- [ ] Custom/cron schedule type (fire time computation)
- [ ] Analytics dashboard
- [ ] Custom sounds / icons in notification designer

### Launch blockers
- [ ] Replace RevenueCat placeholder API keys (`lib/data/services/revenuecat_service.dart`)
- [ ] End-to-end device testing (iOS + Android physical devices)
- [ ] App Store / Play Store metadata and screenshots

## Code Standards

### Must Follow
- `withValues()` NOT `withOpacity()` (deprecated)
- Check `mounted` before `setState` in async operations
- `Logger.info()` for logging (auto-disabled in production)
- Theme properties only — never hardcode colors
- `flutter analyze` must pass with 0 issues before any commit
- All models use Freezed with code-gen (@freezed, copyWith, toJson/fromJson)
- All database operations use Drift typed queries — no raw SQL
- User-facing feedback strings go in `AppStrings` — never hardcode inline

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
- **Gold accent**: #C9A832 (primary), #D4BC5E (light), #A38A1E (dark/pressed)
- **Font**: Inter (bundled in assets/fonts/inter/)
- **Card radius**: 14px
- **Button height**: 48px
- **Bottom nav**: 4 tabs — Home, Templates, History, Settings
- **Snackbars**: Floating, rounded (12px), default dark background
- **Page transitions**: Slide-up (300ms easeOutCubic) for full-screen overlays; fade (400ms) for onboarding

## Key File Locations

| Task | File |
|------|------|
| App entry point | `lib/main.dart` |
| Database tables | `lib/data/database/tables/` |
| Database definition | `lib/data/database/app_database.dart` |
| DAOs | `lib/data/database/daos/notification_dao.dart`, `history_dao.dart` |
| Entity ↔ domain mappers | `lib/data/database/mappers/` |
| Domain models (Freezed) | `lib/domain/models/notification_item.dart`, `history_entry.dart` |
| Schedule type enum | `lib/domain/models/schedule_type.dart` |
| History action enum | `lib/domain/models/history_action.dart` |
| Notification business logic | `lib/domain/services/notification_service.dart` |
| Rolling window scheduler | `lib/domain/services/schedule_service.dart` |
| History recording service | `lib/domain/services/history_service.dart` |
| Plugin wrapper (OS bridge) | `lib/data/services/notification_plugin_service.dart` |
| RevenueCat service | `lib/data/services/revenuecat_service.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Routes | `lib/core/routing/app_router.dart` |
| Colors | `lib/core/constants/app_colors.dart` |
| Sizes/spacing constants | `lib/core/constants/app_sizes.dart` |
| String constants | `lib/core/constants/app_strings.dart` |
| Logger utility | `lib/core/utils/logger.dart` |
| DB + service providers | `lib/presentation/providers/database_provider.dart` |
| Create/Edit form provider | `lib/presentation/providers/create_notification_provider.dart` |
| Notification list provider | `lib/presentation/providers/notification_list_provider.dart` |
| History list provider | `lib/presentation/providers/history_provider.dart` |
| Onboarding provider | `lib/presentation/providers/onboarding_provider.dart` |
| Premium status provider | `lib/presentation/providers/premium_provider.dart` |
| Template list provider | `lib/presentation/providers/template_provider.dart` |
| Home screen | `lib/presentation/screens/home/home_screen.dart` |
| Create/Edit screen | `lib/presentation/screens/create/create_screen.dart` |
| History screen | `lib/presentation/screens/history/history_screen.dart` |
| Settings screen | `lib/presentation/screens/settings/settings_screen.dart` |
| Onboarding screen | `lib/presentation/screens/onboarding/onboarding_screen.dart` |
| Paywall screen | `lib/presentation/screens/premium/paywall_screen.dart` |
| Templates screen | `lib/presentation/screens/templates/templates_screen.dart` |
| Background sync service | `lib/domain/services/background_sync_service.dart` |
| Template service | `lib/domain/services/template_service.dart` |
| Template model (Freezed) | `lib/domain/models/template_item.dart` |
| Built-in templates JSON | `assets/templates/built_in_templates.json` |
| Notification card widget | `lib/presentation/shared/notification_card.dart` |
| Bottom nav scaffold | `lib/presentation/shared/scaffold_with_bottom_nav.dart` |
| Lock-screen preview | `lib/presentation/shared/lock_screen_preview.dart` |
| App icon (source, square) | `assets/icons/app_icon.png` |
| Play Store icon (512x512) | `assets/icons/play_store_icon.png` |
| Icon generator config | `flutter_launcher_icons.yaml` |
| Test helpers (DB + mocks) | `test/helpers/test_database.dart`, `test/helpers/mocks.dart` |
| NotificationService tests | `test/domain/services/notification_service_test.dart` |
| ScheduleService tests | `test/domain/services/schedule_service_test.dart` |
| HistoryService tests | `test/domain/services/history_service_test.dart` |
| Widget smoke test | `test/widget_test.dart` |

## Haptic Patterns

- `HapticFeedback.heavyImpact()` — notification created/deleted, errors
- `HapticFeedback.mediumImpact()` — toggle on/off, confirmations
- `HapticFeedback.lightImpact()` — navigation taps, minor interactions
