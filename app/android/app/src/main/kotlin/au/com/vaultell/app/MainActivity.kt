package au.com.vaultell.app

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth requires a FragmentActivity host; FlutterActivity throws
// "no_fragment_activity" when biometric/PIN auth is requested.
class MainActivity : FlutterFragmentActivity()
