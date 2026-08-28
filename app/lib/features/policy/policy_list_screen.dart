import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/utils/formatters.dart';
import 'policy_detail_screen.dart';
import 'policy_form_screen.dart';

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
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: policies.length,
            itemBuilder: (context, index) {
              final policy = policies[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: type.color.withValues(alpha: 0.12),
                    child: Text(
                      policy.insurer.isNotEmpty ? policy.insurer[0] : '?',
                      style: TextStyle(color: type.color, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(policy.insurer.isEmpty ? 'Unnamed policy' : policy.insurer),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${formatMoney(policy.premiumCents)}/yr · Policy ${policy.policyNumber.isEmpty ? '—' : policy.policyNumber}'),
                      Text(expiryLabel(policy.endDate), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(policy.status),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: policy.status == 'active'
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.grey.withValues(alpha: 0.15),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PolicyDetailScreen(policyId: policy.id, database: database),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (type == InsuranceType.health) {
            final active = await database.policyDao.activePoliciesOfType(type);
            if (active.isNotEmpty) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Health insurance allows only one active policy')),
              );
              return;
            }
          }
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
