import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/app_database.dart';
import '../../core/services/app_lock_service.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/notification_service.dart';
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

  Future<void> _exportBackup() async {
    final json = await BackupService.export(widget.database);
    final bytes = Uint8List.fromList(utf8.encode(json));
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'application/json',
            name: 'insurance_profile_backup.json',
          ),
        ],
        text: 'Insurance Profile backup',
      ),
    );
  }

  Future<void> _importBackup() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picked == null || picked.path == null || !mounted) return;

    String source;
    try {
      source = await File(picked.path!).readAsString();
      BackupService.decode(source); // validate before asking to wipe data
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid backup file: $e')),
      );
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore backup?'),
        content: const Text(
          'This replaces all current data on this device with the backup contents. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restore')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      final policyCount = await BackupService.restore(widget.database, source);
      try {
        final active = await widget.database.policyDao.allActivePolicies();
        await NotificationService.instance.resyncAll(active);
      } catch (_) {
        // Notifications are best-effort on restore.
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup restored ($policyCount policies).')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
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
          const Divider(),
          const ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Backup & Restore'),
            subtitle: Text('Export or restore all local data'),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('Export backup'),
            subtitle: const Text('Share/save a JSON file with all your policies'),
            onTap: _exportBackup,
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Import backup'),
            subtitle: const Text('Replace current data with a backup file'),
            onTap: _importBackup,
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
