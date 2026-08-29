import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../db/app_database.dart';

/// Schedules a single local reminder 37 days before a policy expires.
///
/// Insurers typically send renewal emails ~30 days before expiry; the extra
/// week gives the user time to review options. Everything is on-device.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const int daysBeforeExpiry = 37;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Pure date math (unit-testable): 37 days before [expiry] at 09:00 local.
  static DateTime reminderDateFor(DateTime expiry) {
    final date = DateTime(expiry.year, expiry.month, expiry.day)
        .subtract(const Duration(days: daysBeforeExpiry));
    return DateTime(date.year, date.month, date.day, 9);
  }

  static bool shouldSchedule(DateTime reminder, DateTime now) => reminder.isAfter(now);

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Australia/Brisbane'));
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<void> scheduleExpiryReminder({
    required int policyId,
    required String insurer,
    required DateTime expiryDate,
  }) async {
    await init();
    await _plugin.cancel(id: policyId);

    final reminder = reminderDateFor(expiryDate);
    if (!shouldSchedule(reminder, DateTime.now())) return;

    final scheduledAt = tz.TZDateTime.from(reminder, tz.local);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'policy_expiry',
        'Policy expiry reminders',
        channelDescription: 'Reminders before your insurance policies expire',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: policyId,
      title: 'Policy expiry reminder',
      body: '$insurer expires on ${DateFormat('dd MMM yyyy', 'en_US').format(expiryDate)}',
      scheduledDate: scheduledAt,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelForPolicy(int policyId) async {
    if (!_initialized) return;
    await _plugin.cancel(id: policyId);
  }

  Future<void> resyncAll(Iterable<Policy> policies) async {
    for (final policy in policies.where((p) => p.status == 'active' && p.endDate != null)) {
      await scheduleExpiryReminder(
        policyId: policy.id,
        insurer: policy.insurer,
        expiryDate: policy.endDate!,
      );
    }
  }
}
