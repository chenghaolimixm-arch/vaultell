import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/utils/formatters.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key, required this.policy, required this.database});

  final Policy policy;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('报价对比')),
      body: StreamBuilder<List<Quote>>(
        stream: database.policyDao.watchQuotesForPolicy(policy.id),
        builder: (context, snapshot) {
          final quotes = snapshot.data ?? const <Quote>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⚠️ 本页所有报价均为示例数据（mock），不代表任何保险公司的真实报价。',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 12),
              _currentPolicyCard(policy),
              const SizedBox(height: 12),
              if (quotes.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('还没有可对比的报价。回到保单详情页添加示例报价。', textAlign: TextAlign.center),
                )
              else
                for (final quote in quotes) _quoteCard(quote),
            ],
          );
        },
      ),
    );
  }

  Widget _currentPolicyCard(Policy policy) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('当前保单', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _row('保险公司', policy.insurer),
            _row('年保费', formatMoney(policy.premiumCents)),
            _row('Excess', formatMoney(policy.excessCents)),
            _row('保额', formatMoney(policy.sumInsuredCents)),
          ],
        ),
      ),
    );
  }

  Widget _quoteCard(Quote quote) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(quote.insurer, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (quote.isMock)
                  const Chip(label: Text('示例'), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: 8),
            _row('年保费', formatMoney(quote.premiumCents)),
            _row('Excess', formatMoney(quote.excessCents)),
            _row('保额', formatMoney(quote.sumInsuredCents)),
            if (quote.coverSummary.isNotEmpty) _row('保障摘要', quote.coverSummary),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
