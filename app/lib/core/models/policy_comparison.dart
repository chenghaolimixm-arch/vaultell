import 'package:flutter/foundation.dart';

/// Year-over-year premium comparison for a policy.
@immutable
class PremiumChange {
  const PremiumChange({required this.lastYearCents, required this.currentCents});

  final int lastYearCents;
  final int currentCents;

  bool get hasData => lastYearCents > 0;
  int get differenceCents => currentCents - lastYearCents;

  /// Percentage change relative to last year; null when last year is 0.
  double? get percentChange =>
      lastYearCents == 0 ? null : (differenceCents / lastYearCents) * 100;
}
