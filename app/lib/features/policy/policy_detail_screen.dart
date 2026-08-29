import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/db/app_database.dart';
import '../../core/models/insurance_type.dart';
import '../../core/models/insurer_catalog.dart';
import '../../core/services/document_storage_service.dart';
import '../../core/services/notification_service.dart';
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
      appBar: AppBar(title: const Text('Policy details')),
      body: StreamBuilder<Policy?>(
        stream: database.policyDao.watchPolicy(policyId),
        builder: (context, snapshot) {
          final policy = snapshot.data;
          if (policy == null) {
            return const Center(child: Text('Policy not found or deleted'));
          }
          final type = InsuranceType.fromName(policy.insuranceType);
          final insurer = InsurerCatalog.byKey(policy.insurerKey) ??
              InsurerCatalog.byName(policy.insurer);
          final claimUrl = insurer?.claimUrlFor(type);
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
                      _kv('Insurer', policy.insurer),
                      _kv('Policy number', policy.policyNumber),
                      _kv('Cover type', policy.policyType),
                      _kv('Annual premium', formatMoney(policy.premiumCents)),
                      _kv('Excess', formatMoney(policy.excessCents)),
                      _kv('Sum insured', formatMoney(policy.sumInsuredCents)),
                      _kv('Policy Expiry Date', formatDate(policy.endDate)),
                      _kv('Expiry countdown', expiryLabel(policy.endDate)),
                      _kv('Status', policy.status),
                      if (policy.notes.isNotEmpty) _kv('Notes', policy.notes),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _QuoteSection(policyId: policyId, database: database),
              const SizedBox(height: 8),
              if (claimUrl != null)
                FilledButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Make a Claim'),
                  onPressed: () async {
                    final uri = Uri.tryParse(claimUrl);
                    if (uri == null) return;
                    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                    if (!launched && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the claims page. Please try again.')),
                      );
                    }
                  },
                )
              else
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Make a Claim (no link for custom insurer)'),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('Compare Quotes'),
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
                      label: const Text('Upload File'),
                      onPressed: () async {
                        final picked = await FilePicker.pickFile(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                        );
                        if (picked == null || picked.path == null) return;
                        final savedPath = await DocumentStorageService().savePickedFile(
                          sourcePath: picked.path!,
                          fileName: picked.name,
                        );
                        await database.policyDao.addDocument(
                          policyId: policyId,
                          kind: 'renewal',
                          fileName: picked.name,
                          localPath: savedPath,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Policy file saved on this device')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _DocumentsSection(policyId: policyId, database: database),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
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
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete policy?'),
                            content: const Text('This also removes linked quotes and file records (local files need manual cleanup). This cannot be undone.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await database.policyDao.deletePolicy(policyId);
                          await NotificationService.instance.cancelForPolicy(policyId);
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

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.policyId, required this.database});

  final int policyId;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Document>>(
      stream: database.policyDao.watchDocumentsForPolicy(policyId),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? const <Document>[];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Documents', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (docs.isEmpty)
                  const Text('No files yet. Upload a policy file to view it here.', style: TextStyle(color: Colors.grey)),
                for (final doc in docs)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(doc.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(doc.kind),
                    trailing: const Icon(Icons.folder, size: 20),
                  ),
              ],
            ),
          ),
        );
      },
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
                    Text('Quotes', style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add quote',
                      onPressed: () => _showAddQuoteDialog(context),
                    ),
                  ],
                ),
                if (quotes.isEmpty)
                  const Text('No quotes yet. Tap + to add (example data in MVP).', style: TextStyle(color: Colors.grey)),
                for (final quote in quotes)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(quote.insurer),
                    subtitle: Text(
                      '${formatMoney(quote.premiumCents)}/yr · excess ${formatMoney(quote.excessCents)}',
                    ),
                    trailing: quote.isMock
                        ? const Chip(label: Text('Example'), visualDensity: VisualDensity.compact)
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
        title: const Text('Add quote (example data)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: insurer, decoration: const InputDecoration(labelText: 'Insurer *')),
              TextField(
                controller: premium,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Annual premium (AUD)'),
              ),
              TextField(
                controller: excess,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Excess (AUD)'),
              ),
              TextField(controller: cover, decoration: const InputDecoration(labelText: 'Cover summary')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
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
