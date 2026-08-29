import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/services/notification_service.dart';

void main() {
  test('reminder fires 37 days before expiry at 09:00', () {
    final reminder = NotificationService.reminderDateFor(DateTime(2026, 12, 31));
    expect(reminder, DateTime(2026, 11, 24, 9));
  });

  test('reminder crosses month boundaries correctly', () {
    final reminder = NotificationService.reminderDateFor(DateTime(2026, 10, 15));
    expect(reminder, DateTime(2026, 9, 8, 9));
  });

  test('reminder in the past is not scheduled', () {
    final now = DateTime(2026, 8, 29, 12);
    final pastReminder = DateTime(2026, 8, 20, 9);
    expect(NotificationService.shouldSchedule(pastReminder, now), isFalse);

    final futureReminder = DateTime(2026, 9, 20, 9);
    expect(NotificationService.shouldSchedule(futureReminder, now), isTrue);
  });
}
