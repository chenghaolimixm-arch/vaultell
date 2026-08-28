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
        title: const Text('Insurance Wallet'),
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

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: type.color.withValues(alpha: 0.12),
          child: Icon(type.icon, color: type.color),
        ),
        title: Text(type.label),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              active.isEmpty
                  ? 'No active policies'
                  : '${active.length} active ${active.length == 1 ? 'policy' : 'policies'}',
            ),
            if (nextExpiry != null)
              Text(
                'Next expiry: ${expiryLabel(nextExpiry)}',
                style: const TextStyle(fontSize: 12, color: Colors.orange),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add ${type.label}',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PolicyListScreen(type: type, database: database),
            ),
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PolicyListScreen(type: type, database: database),
          ),
        ),
      ),
    );
  }
}
