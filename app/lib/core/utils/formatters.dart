import 'package:intl/intl.dart';

String formatMoney(int cents) {
  final dollars = cents / 100;
  return '\$${dollars.toStringAsFixed(2)}';
}

String formatMoneyChange(int cents) {
  final dollars = cents / 100;
  return cents >= 0 ? '+\$${dollars.toStringAsFixed(2)}' : '-\$${dollars.abs().toStringAsFixed(2)}';
}

String formatDate(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('dd MMM yyyy', 'en_US').format(date);
}

/// Whole days from today until [date]; negative when past.
int? daysUntil(DateTime? date) {
  if (date == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  return target.difference(today).inDays;
}

String expiryLabel(DateTime? date) {
  final days = daysUntil(date);
  if (days == null) return 'No expiry date set';
  if (days < 0) return 'Expired on ${formatDate(date)}';
  if (days == 0) return 'Expires today';
  return '$days days left (${formatDate(date)})';
}

int parseDollarsToCents(String input) {
  final cleaned = input.replaceAll(',', '').trim();
  final value = double.tryParse(cleaned) ?? 0;
  return (value * 100).round();
}
