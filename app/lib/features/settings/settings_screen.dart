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
          localizedReason: '解锁 Insurance Profile App',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (ok) {
          if (!mounted) return;
          setState(() => _appLockEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App 锁已启用（偏好持久化将在 Phase 1 实现）')),
          );
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设备不支持生物识别，App 锁暂不可用')),
        );
      }
    } else {
      setState(() => _appLockEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('App 锁（生物识别）'),
            subtitle: const Text('打开 App 时要求验证'),
            value: _appLockEnabled,
            onChanged: _toggleAppLock,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('隐私说明'),
            subtitle: const Text('数据只保存在本机，不上传服务器'),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('隐私说明'),
                content: const Text(
                  '本 App 采用纯本地存储：你的保单信息、文件和提取结果只保存在这台设备上，'
                  '不会上传到任何服务器，也不会出售或共享给第三方。'
                  '\n\n未来若提供云端 AI 或备份功能，将采用逐份授权 + 端到端加密，并提前更新本说明。',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('知道了')),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('关于'),
            subtitle: Text('Insurance Profile App v0.1 · MVP'),
          ),
        ],
      ),
    );
  }
}
