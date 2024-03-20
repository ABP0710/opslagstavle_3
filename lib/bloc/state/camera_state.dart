import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opslagstavle_3/bloc/state/bulletin_board_state.dart';
import 'package:opslagstavle_3/bloc/state/image_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opslagstavle_3/main.dart';

Future<void> runCamera() async {}

// CameraApp is the runCamera Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  late CameraController controller;
  List<String> ?capturedImages = [];
  //File? _imageFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void takePic() async {
    try {
      final image = await controller.takePicture();
      await saveImg(image);
      
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  //save img to a base64 string using sharedPreference
  Future <void> saveImg(image) async {
    // Convert the image to base64
    final bytes = await File(image.path).readAsBytes();
    final String base64Image = base64Encode(bytes);

    // Save the base64 image to shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> capturedImages = prefs.getStringList('captured_images') ?? [];

    // Add the new image to the list
    capturedImages.add(base64Image);

    // Save the updated list to SharedPreferences
    await prefs.setStringList('captured_images', capturedImages);

    // Write to the console for test/controle
    debugPrint('Base64 Image: $base64Image');
  }

  Future<List<String>?> getListOfBase64Images() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? capturedImages = prefs.getStringList('captured_images');

    return capturedImages;
  }

  // Navigate methods for buttom bar
  void _navigateToMyApp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  void _navigateToBulletinApp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BulletinApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
        body: CameraPreview(controller),
        floatingActionButton: IconButton(          
          icon: const Icon(Icons.camera),
          onPressed: () {
            takePic;
            
          },            
          color: Colors.black,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => _navigateToMyApp(context),
              ),
              IconButton(
                icon: const Icon(Icons.picture_in_picture_alt_outlined),
                onPressed: () => _navigateToBulletinApp(context),
              ),
            ],
          ),
        ));
  }
}
