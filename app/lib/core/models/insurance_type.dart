import 'package:flutter/material.dart';

/// The insurance categories supported by the app.
///
/// Every type supports multiple active policies per user.
enum InsuranceType {
  car('Car Insurance', Icons.directions_car, Color(0xFF1565C0), 'car'),
  home('Home Insurance', Icons.home, Color(0xFF2E7D32), 'property'),
  landlord('Landlord Insurance', Icons.apartment, Color(0xFF6A1B9A), 'property'),
  pet('Pet Insurance', Icons.pets, Color(0xFFEF6C00), 'pet');

  const InsuranceType(this.label, this.icon, this.color, this.subjectType);

  final String label;
  final IconData icon;
  final Color color;

  /// The kind of asset (car/property/pet) this policy is usually attached to.
  final String? subjectType;

  bool get allowsMultiple => true;

  static InsuranceType fromName(String name) =>
      InsuranceType.values.firstWhere((t) => t.name == name, orElse: () => InsuranceType.car);
}
