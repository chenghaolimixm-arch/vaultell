import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/db/app_database.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _localAuth = LocalAuthentication();
  bool _appLockEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final available = await _localAuth.canCheckBiometrics;
      if (available && mounted) {
        // Phase 1: persist this preference locally (e.g. shared_preferences)
        // and gate app startup with authentication.
      }
    } catch (_) {
      // Biometric APIs are unavailable on this device/platform.
    }
  }

  Future<void> _toggleAppLock(bool enabled) async {
    if (enabled) {
      try {
        final ok = await _localAuth.authenticate(
          localizedReason: 'Unlock Insurance Profile App',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (ok) {
          if (!mounted) return;
          setState(() => _appLockEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App Lock enabled (preference persistence lands in Phase 1)')),
          );
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication is not available on this device')),
        );
      }
    } else {
      setState(() => _appLockEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('App Lock (biometrics)'),
            subtitle: const Text('Require verification when opening the app'),
            value: _appLockEnabled,
            onChanged: _toggleAppLock,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy'),
            subtitle: const Text('Data stays on this device and is never uploaded'),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Privacy'),
                content: const Text(
                  'This app is local-first: your policy details, files and extraction results are stored '
                  'only on this device, never uploaded to any server, and never sold or shared with third parties.'
                  '\n\nIf cloud AI or backup features are added in the future, they will use per-document '
                  'consent and end-to-end encryption, and this notice will be updated first.',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it')),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Insurance Profile App v0.1 · MVP'),
          ),
        ],
      ),
    );
  }
}
