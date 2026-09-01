import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../db/app_database.dart';

/// Schedules local reminders at 30, 15, 7 and 3 days before a policy expires.
///
/// Reminders are re-scheduled whenever the policy is updated (for example
/// after renewal) and cancelled when the policy is deleted or no longer
/// active. Everything is on-device.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const List<int> reminderDays = [30, 15, 7, 3];

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Pure date math (unit-testable): [daysBefore] days before [expiry] at
  /// 09:00 local time.
  static DateTime reminderDateFor(DateTime expiry, int daysBefore) {
    final date = DateTime(expiry.year, expiry.month, expiry.day)
        .subtract(Duration(days: daysBefore));
    return DateTime(date.year, date.month, date.day, 9);
  }

  static bool shouldSchedule(DateTime reminder, DateTime now) => reminder.isAfter(now);

  /// Stable unique notification id for one reminder of a policy.
  static int notificationIdFor(int policyId, int index) => policyId * 10 + index;

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
    await cancelForPolicy(policyId);

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

    final now = DateTime.now();
    final expiryText = DateFormat('dd MMM yyyy', 'en_US').format(expiryDate);
    for (var i = 0; i < reminderDays.length; i++) {
      final days = reminderDays[i];
      final reminder = reminderDateFor(expiryDate, days);
      if (!shouldSchedule(reminder, now)) continue;

      await _plugin.zonedSchedule(
        id: notificationIdFor(policyId, i),
        title: days == 1 ? 'Policy expires tomorrow' : 'Policy expires in $days days',
        body: '$insurer expires on $expiryText',
        scheduledDate: tz.TZDateTime.from(reminder, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelForPolicy(int policyId) async {
    if (!_initialized) return;
    for (var i = 0; i < reminderDays.length; i++) {
      await _plugin.cancel(id: notificationIdFor(policyId, i));
    }
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
