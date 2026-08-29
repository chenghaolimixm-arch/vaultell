import 'package:flutter/material.dart';

import '../../core/services/app_lock_service.dart';

/// Shows a lock screen on startup when the App Lock preference is enabled.
class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  final AppLockService _service = AppLockService();

  bool? _locked;
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final enabled = await _service.isEnabled();
    if (!mounted) return;
    setState(() => _locked = enabled);
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final ok = await _service.authenticate();
    if (!mounted) return;
    setState(() {
      _authenticating = false;
      if (ok) _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_locked == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_locked == true) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Insurance Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unlock with biometrics or your device passcode.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _authenticating ? null : _unlock,
                    icon: _authenticating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.fingerprint),
                    label: Text(_authenticating ? 'Unlocking…' : 'Unlock'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
