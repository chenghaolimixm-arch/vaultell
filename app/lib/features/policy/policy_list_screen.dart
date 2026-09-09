import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/utils/formatters.dart';
import 'policy_detail_screen.dart';
import 'policy_form_screen.dart';

/// Approximate brand colours for common Australian insurers, keyed by their
/// [InsurerCatalog] key. Falls back to the insurance type colour when unknown.
const Map<String, Color> _insurerBrandColors = {
  'allianz': Color(0xFF003781),
  'aami': Color(0xFF009FE3),
  'racq': Color(0xFFE4002B),
  'racv': Color(0xFF00A9E0),
  'nrma': Color(0xFF00B14F),
  'youi': Color(0xFFF7941E),
  'budget-direct': Color(0xFFB01E24),
  'gio': Color(0xFF0072BC),
  'qbe': Color(0xFF002E5D),
  'suncorp': Color(0xFFFF7A00),
  'commbank': Color(0xFF003087),
  'terri-scheer': Color(0xFF00A5A0),
  'rspca-pet': Color(0xFFE5114B),
  'petbarn': Color(0xFFB01F24),
  'cgu': Color(0xFF005A9E),
  'bingle': Color(0xFF00A7E1),
  'just-car': Color(0xFF009BDE),
  'apia': Color(0xFF00B0B9),
  'real-insurance': Color(0xFF003E7E),
  'woolworths': Color(0xFF0077C8),
  'coles': Color(0xFFE4002B),
  'australia-post': Color(0xFFE6280A),
  'rac-wa': Color(0xFF00447C),
  'wfi': Color(0xFF1D2E5C),
  'bow-wow-meow': Color(0xFFE5114B),
  'petcover': Color(0xFF00858A),
};

Color _brandColor(String? key, Color fallback) =>
    key == null ? fallback : (_insurerBrandColors[key] ?? fallback);

/// Urgency colour for a renewal countdown.
Color _urgencyColor(int? days) {
  if (days == null) return const Color(0xFF9E9E9E);
  if (days < 0) return const Color(0xFFD32F2F); // expired
  if (days <= 7) return const Color(0xFFD32F2F); // urgent
  if (days <= 30) return const Color(0xFFF59A00); // soon
  if (days <= 60) return const Color(0xFFF9A825); // coming up
  return const Color(0xFF2E7D32); // plenty of time
}

String _daysLabel(int? days) {
  if (days == null) return 'No expiry';
  if (days < 0) return 'Expired';
  if (days == 0) return 'Today';
  return '$days day${days == 1 ? '' : 's'}';
}

class PolicyListScreen extends StatelessWidget {
  const PolicyListScreen({super.key, required this.type, required this.database});

  final InsuranceType type;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(type.label)),
      body: StreamBuilder<List<Policy>>(
        stream: database.policyDao.watchPoliciesByType(type),
        builder: (context, snapshot) {
          final policies = snapshot.data ?? const <Policy>[];
          if (policies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(type.icon, size: 56, color: type.color.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  const Text('No policies yet. Tap + to add one.'),
                ],
              ),
            );
          }
          // Soonest-renewing policies first (null expiry last).
          final ordered = [...policies]
            ..sort((a, b) {
              final ad = a.endDate, bd = b.endDate;
              if (ad == null && bd == null) return 0;
              if (ad == null) return 1;
              if (bd == null) return -1;
              return ad.compareTo(bd);
            });
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: ordered.length,
            itemBuilder: (context, index) => _PolicyCard(
              type: type,
              policy: ordered[index],
              database: database,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PolicyFormScreen(type: type, database: database),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Policy'),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({
    required this.type,
    required this.policy,
    required this.database,
  });

  final InsuranceType type;
  final Policy policy;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final days = daysUntil(policy.endDate);
    final brand = _brandColor(policy.insurerKey, type.color);
    final initial = policy.insurer.isNotEmpty ? policy.insurer[0].toUpperCase() : '?';
    final premium = '${formatMoney(policy.premiumCents)}/yr';
    final policyNo = policy.policyNumber.isEmpty ? '—' : 'Policy ${policy.policyNumber}';

    void open() => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PolicyDetailScreen(policyId: policy.id, database: database),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: open,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6, color: type.color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: brand,
                          child: Text(
                            initial,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                policy.insurer.isEmpty ? 'Unnamed policy' : policy.insurer,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1B1D),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                premium,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3036),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                policyNo,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF797C84)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _urgencyColor(days),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _daysLabel(days),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              policy.endDate == null ? 'No date' : formatDate(policy.endDate),
                              style: const TextStyle(fontSize: 11, color: Color(0xFF8C8F96)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
