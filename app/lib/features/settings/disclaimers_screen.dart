import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Privacy statement and legal disclaimers shown to users.
class DisclaimersScreen extends StatelessWidget {
  const DisclaimersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Disclaimers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FullPolicyLink(),
          _Section(
            title: 'Your data stays on your device',
            body:
                'This app is local-first. Your policy details, uploaded documents and extraction results are '
                'stored only on this device and are never uploaded to a server, sold, or shared with third parties. '
                'If cloud AI or backup features are added in the future, they will use per-document consent and '
                'end-to-end encryption, and this notice will be updated first.',
          ),
          _Section(
            title: 'Information only — not insurance advice',
            body:
                'Insurance Profile App is a record-keeping and information tool. It does not provide financial '
                'or insurance advice, and it is not a licensed insurance adviser or broker. Nothing in the app '
                'should be treated as a recommendation to buy, renew, or cancel any particular policy.',
          ),
          _Section(
            title: 'Quotes shown in the app are examples',
            body:
                'Quote comparison features use example (mock) data unless clearly sourced from a real insurer '
                'document you provided. Example figures never represent real insurer pricing, and the app will '
                'never invent a quote and present it as real.',
          ),
          _Section(
            title: 'You decide',
            body:
                'Insurance decisions are yours alone. Before making any decision, review the product disclosure '
                'statement (PDS) of any policy you are considering and contact the insurer or a licensed adviser '
                'with any questions.',
          ),
          _Section(
            title: 'Health information is sensitive',
            body:
                'Health insurance details are treated as sensitive information. They stay on your device and are '
                'subject to the same local-first rules described above.',
          ),
          _Section(
            title: 'Not a substitute for professional advice',
            body:
                'This app does not replace legal, financial, tax or insurance advice. If you are unsure, speak to '
                'a qualified professional.',
          ),
        ],
      ),
    );
  }
}

class _FullPolicyLink extends StatelessWidget {
  const _FullPolicyLink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.open_in_new),
        label: const Text('Read the full privacy policy'),
        onPressed: () async {
          final uri = Uri.parse('https://stalwart-cobbler-3bf933.netlify.app/');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(height: 1.45)),
        ],
      ),
    );
  }
}
