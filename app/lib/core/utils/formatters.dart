import 'package:intl/intl.dart';

String formatMoney(int cents) {
  final dollars = cents / 100;
  return '\$${dollars.toStringAsFixed(2)}';
}

String formatDate(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('dd MMM yyyy').format(date);
}

/// Whole days from today until [date]; negative when past.
int? daysUntil(DateTime? date) {
  if (date == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  return target.difference(today).inDays;
}

String renewalLabel(DateTime? date) {
  final days = daysUntil(date);
  if (days == null) return '未设置续保日期';
  if (days < 0) return '已于 ${formatDate(date)} 到期';
  if (days == 0) return '今天到期';
  return '还有 $days 天（${formatDate(date)}）';
}

int parseDollarsToCents(String input) {
  final cleaned = input.replaceAll(',', '').trim();
  final value = double.tryParse(cleaned) ?? 0;
  return (value * 100).round();
}
