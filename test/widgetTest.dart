import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opslagstavle_3/bloc/state/camera_state.dart';



void main() {
  testWidgets('Test CameraApp widget', (WidgetTester tester) async {
    // Build CameraApp widget
    await tester.pumpWidget(const MaterialApp(
      home: CameraApp(),
    ));

    // Verify that CameraPreview is present
    expect(find.byType(CameraPreview), findsOneWidget);

    // Verify that the floating action button is present
    expect(find.byIcon(Icons.camera), findsOneWidget);

    // Tap on the floating action button
    await tester.tap(find.byIcon(Icons.camera));
    await tester.pump();
  });
}
