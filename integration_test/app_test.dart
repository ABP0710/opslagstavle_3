import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opslagstavle_3/main.dart';
import 'package:integration_test/integration_test.dart';



Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Grand access to camera with adb, because the Flutter integration test
  // can't interact with native buttons.
  await Process.run('adb', [
    'shell',
    'pm',
    'grant',
    'dev.steenbakker.mobile_scanner_example',
    'android.permission.CAMERA'
  ]);

  await integrationDriver();
}

integrationDriver() {

  group('end-to-end test', () {
    testWidgets('tap on the camera button, verify image',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const MyApp());

      // Verify the the app starts on the home page.
      expect(find.text('Velkommen til din nye foto opslagstagle'), findsOneWidget);

      // Finds the Buttom bar, locade the carera button to tap on.
      //expect(find.byIcon(Icons.camera), findsOneWidget);
      final fab = find.byIcon(Icons.camera);

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      //expect(find.text('1'), findsOneWidget);
    });
  });
}