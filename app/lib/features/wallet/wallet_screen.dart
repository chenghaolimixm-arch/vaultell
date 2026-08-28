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
            tooltip: '设置',
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
                  '所有数据仅保存在本机，不会上传到任何服务器。',
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
            Text('${active.length} 份有效保单${active.isNotEmpty ? '' : '（暂无）'}'),
            if (nextExpiry != null)
              Text(
                '下一到期：${expiryLabel(nextExpiry)}',
                style: const TextStyle(fontSize: 12, color: Colors.orange),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: '添加${type.label}',
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
