import 'package:mockito/annotations.dart';
import 'package:custom_notify/data/services/notification_plugin_service.dart';
import 'package:custom_notify/domain/services/schedule_service.dart';

/// Generate null-safe mocks for services that require OS-level APIs.
///
/// Run `dart run build_runner build --delete-conflicting-outputs` to
/// regenerate mocks.g.dart after modifying this list.
@GenerateNiceMocks([
  MockSpec<NotificationPluginService>(),
  MockSpec<ScheduleService>(),
])
void main() {}
