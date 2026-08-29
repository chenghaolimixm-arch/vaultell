import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/services/app_lock_service.dart';
import 'disclaimers_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _appLock = AppLockService();
  bool _appLockEnabled = false;
  bool _hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _appLock.isEnabled();
    final hasBiometrics = await _appLock.canUseBiometrics();
    if (!mounted) return;
    setState(() {
      _appLockEnabled = enabled;
      _hasBiometrics = hasBiometrics;
    });
  }

  Future<void> _toggleAppLock(bool enabled) async {
    if (enabled) {
      final ok = await _appLock.authenticate();
      if (ok) {
        await _appLock.setEnabled(true);
        if (!mounted) return;
        setState(() => _appLockEnabled = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App Lock enabled. It will be required next time the app opens.')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification failed, App Lock not enabled')),
        );
      }
    } else {
      await _appLock.setEnabled(false);
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
            title: const Text('App Lock'),
            subtitle: const Text('Require verification when opening the app'),
            value: _appLockEnabled,
            onChanged: _toggleAppLock,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy & Disclaimers'),
            subtitle: const Text('Local-first storage, information only, not insurance advice'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DisclaimersScreen()),
            ),
          ),
          if (!_hasBiometrics)
            const ListTile(
              dense: true,
              leading: Icon(Icons.info_outline, size: 20),
              title: Text(
                'Biometrics unavailable on this device — App Lock will use your device passcode.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
