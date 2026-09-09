import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/utils/formatters.dart';
import '../policy/policy_list_screen.dart';
import '../settings/settings_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insurance Wallet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingsScreen(database: database)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Policy>>(
        stream: database.policyDao.watchAllPolicies(),
        builder: (context, snapshot) {
          final policies = snapshot.data ?? const <Policy>[];
          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            children: [
              for (final type in InsuranceType.values)
                _TypeCard(type: type, policies: policies, database: database),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'All data stays on this device. Nothing is uploaded to any server.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.type, required this.policies, required this.database});

  final InsuranceType type;
  final List<Policy> policies;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    final ofType = policies.where((p) => p.insuranceType == type.name).toList();
    final active = ofType.where((p) => p.status == 'active').toList();
    final expiryDates = active.map((p) => p.endDate).whereType<DateTime>().toList();
    final nextExpiry = expiryDates.isEmpty
        ? null
        : expiryDates.reduce((a, b) => a.isBefore(b) ? a : b);

    void open() => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PolicyListScreen(type: type, database: database),
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
                          radius: 26,
                          backgroundColor: type.color.withValues(alpha: 0.14),
                          child: Icon(type.icon, color: type.color, size: 26),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.label,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1B1D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                active.isEmpty
                                    ? 'No active policies'
                                    : '${active.length} active ${active.length == 1 ? 'policy' : 'policies'}',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B70)),
                              ),
                              if (nextExpiry != null) ...[
                                const SizedBox(height: 3),
                                Text(
                                  'Next expiry: ${expiryLabel(nextExpiry)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFF59A00),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF6B6B70)),
                          tooltip: 'Add ${type.label}',
                          onPressed: open,
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
