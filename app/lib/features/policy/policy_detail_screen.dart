import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/utils/formatters.dart';
import '../comparison/comparison_screen.dart';
import 'policy_form_screen.dart';

class PolicyDetailScreen extends StatelessWidget {
  const PolicyDetailScreen({super.key, required this.policyId, required this.database});

  final int policyId;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('保单详情')),
      body: StreamBuilder<Policy?>(
        stream: database.policyDao.watchPolicy(policyId),
        builder: (context, snapshot) {
          final policy = snapshot.data;
          if (policy == null) {
            return const Center(child: Text('保单不存在或已删除'));
          }
          final type = InsuranceType.fromName(policy.insuranceType);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(type.icon, color: type.color),
                          const SizedBox(width: 8),
                          Text(type.label, style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _kv('保险公司', policy.insurer),
                      _kv('保单号', policy.policyNumber),
                      _kv('保障类型', policy.policyType),
                      _kv('年保费', formatMoney(policy.premiumCents)),
                      _kv('Excess', formatMoney(policy.excessCents)),
                      _kv('保额', formatMoney(policy.sumInsuredCents)),
                      _kv('续保日期', formatDate(policy.renewalDate)),
                      _kv('续保倒计时', renewalLabel(policy.renewalDate)),
                      _kv('状态', policy.status),
                      if (policy.notes.isNotEmpty) _kv('备注', policy.notes),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _QuoteSection(policyId: policyId, database: database),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('报价对比'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ComparisonScreen(policy: policy, database: database),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('上传文件'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('文件上传将在 Phase 1 里程碑实现（本地存储）')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('编辑'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PolicyFormScreen(type: type, database: database, policy: policy),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('删除'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('删除保单？'),
                            content: const Text('将同时删除关联的报价和文件记录（本地文件需手动清理）。此操作不可撤销。'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await database.policyDao.deletePolicy(policyId);
                          if (context.mounted) Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _QuoteSection extends StatelessWidget {
  const _QuoteSection({required this.policyId, required this.database});

  final int policyId;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Quote>>(
      stream: database.policyDao.watchQuotesForPolicy(policyId),
      builder: (context, snapshot) {
        final quotes = snapshot.data ?? const <Quote>[];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('报价', style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: '添加报价',
                      onPressed: () => _showAddQuoteDialog(context),
                    ),
                  ],
                ),
                if (quotes.isEmpty)
                  const Text('暂无报价。点 + 添加（MVP 为示例数据）', style: TextStyle(color: Colors.grey)),
                for (final quote in quotes)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(quote.insurer),
                    subtitle: Text(
                      '${formatMoney(quote.premiumCents)}/年 · excess ${formatMoney(quote.excessCents)}',
                    ),
                    trailing: quote.isMock
                        ? const Chip(label: Text('示例'), visualDensity: VisualDensity.compact)
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddQuoteDialog(BuildContext context) async {
    final insurer = TextEditingController();
    final premium = TextEditingController();
    final excess = TextEditingController();
    final cover = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加报价（示例数据）'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: insurer, decoration: const InputDecoration(labelText: '保险公司 *')),
              TextField(
                controller: premium,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: '年保费（AUD）'),
              ),
              TextField(
                controller: excess,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Excess（AUD）'),
              ),
              TextField(controller: cover, decoration: const InputDecoration(labelText: '保障摘要')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('保存')),
        ],
      ),
    );

    if (saved == true && insurer.text.trim().isNotEmpty) {
      await database.policyDao.addQuote(
        policyId: policyId,
        insurer: insurer.text.trim(),
        premiumCents: parseDollarsToCents(premium.text),
        excessCents: parseDollarsToCents(excess.text),
        coverSummary: cover.text.trim(),
        isMock: true,
      );
    }
  }
}
