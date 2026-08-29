import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/services/app_lock_service.dart';
import 'package:insurance_profile_app/features/settings/app_lock_gate.dart';
import 'package:insurance_profile_app/features/settings/disclaimers_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('app lock preference persists across instances', () async {
    final service = AppLockService();
    expect(await service.isEnabled(), isFalse);

    await service.setEnabled(true);
    expect(await service.isEnabled(), isTrue);
    expect(await AppLockService().isEnabled(), isTrue);

    await service.setEnabled(false);
    expect(await service.isEnabled(), isFalse);
  });

  testWidgets('app lock gate shows child when disabled', (tester) async {
    SharedPreferences.setMockInitialValues({'app_lock_enabled': false});
    await tester.pumpWidget(
      const MaterialApp(home: AppLockGate(child: Text('wallet'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('wallet'), findsOneWidget);
  });

  testWidgets('app lock gate shows lock screen when enabled', (tester) async {
    SharedPreferences.setMockInitialValues({'app_lock_enabled': true});
    await tester.pumpWidget(
      const MaterialApp(home: AppLockGate(child: Text('wallet'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Unlock'), findsOneWidget);
    expect(find.text('wallet'), findsNothing);
  });

  testWidgets('disclaimers screen renders key sections', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DisclaimersScreen()));
    expect(find.text('Your data stays on your device'), findsOneWidget);
    expect(find.text('Information only — not insurance advice'), findsOneWidget);
    expect(find.text('Quotes shown in the app are examples'), findsOneWidget);
  });
}
