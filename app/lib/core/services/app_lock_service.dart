import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and enforces the App Lock preference on this device.
class AppLockService {
  static const String _prefKey = 'app_lock_enabled';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
  }

  Future<bool> canUseBiometrics() async {
    final auth = LocalAuthentication();
    try {
      return await auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Verifies the user with biometrics, falling back to the device passcode.
  Future<bool> authenticate() async {
    final auth = LocalAuthentication();
    try {
      return await auth.authenticate(
        localizedReason: 'Unlock Insurance Profile App',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
