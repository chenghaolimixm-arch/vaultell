import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/services/notification_service.dart';

void main() {
  test('reminder days are 30, 15, 7 and 3', () {
    expect(NotificationService.reminderDays, [30, 15, 7, 3]);
  });

  test('reminder dates compute correctly at 09:00', () {
    final expiry = DateTime(2026, 12, 31);
    expect(NotificationService.reminderDateFor(expiry, 30), DateTime(2026, 12, 1, 9));
    expect(NotificationService.reminderDateFor(expiry, 15), DateTime(2026, 12, 16, 9));
    expect(NotificationService.reminderDateFor(expiry, 7), DateTime(2026, 12, 24, 9));
    expect(NotificationService.reminderDateFor(expiry, 3), DateTime(2026, 12, 28, 9));
  });

  test('reminder dates cross month boundaries correctly', () {
    final expiry = DateTime(2026, 10, 15);
    expect(NotificationService.reminderDateFor(expiry, 30), DateTime(2026, 9, 15, 9));
    expect(NotificationService.reminderDateFor(expiry, 15), DateTime(2026, 9, 30, 9));
    expect(NotificationService.reminderDateFor(expiry, 7), DateTime(2026, 10, 8, 9));
    expect(NotificationService.reminderDateFor(expiry, 3), DateTime(2026, 10, 12, 9));
  });

  test('reminder in the past is not scheduled', () {
    final now = DateTime(2026, 8, 29, 12);
    final pastReminder = DateTime(2026, 8, 20, 9);
    expect(NotificationService.shouldSchedule(pastReminder, now), isFalse);

    final futureReminder = DateTime(2026, 9, 20, 9);
    expect(NotificationService.shouldSchedule(futureReminder, now), isTrue);
  });

  test('notification ids are unique per reminder and policy', () {
    final ids = <int>{};
    for (var policyId = 1; policyId <= 3; policyId++) {
      for (var i = 0; i < NotificationService.reminderDays.length; i++) {
        ids.add(NotificationService.notificationIdFor(policyId, i));
      }
    }
    expect(ids.length, 12);
  });
}
