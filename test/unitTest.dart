
import 'package:flutter_test/flutter_test.dart';
import 'package:opslagstavle_3/bloc/state/bulletin_board_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Test getCapturedImages method', () async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({'captured_images': ['base64_encoded_image']});

    // Create instance of BulletinApp
    final bulletinApp = BulletinAppState();

    // Call getCapturedImages function
    await BulletinAppState().getCapturedImages(); 

    // Access capturedImages variable and check if it's not null and contains expected value
    expect(bulletinApp.capturedImages, isNotNull);
    expect(bulletinApp.capturedImages, isNotEmpty);
    expect(bulletinApp.capturedImages.first, 'base64_encoded_image');
  });
}
