import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:opslagstavle_3/bloc/state/camera_state.dart';
import 'package:opslagstavle_3/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulletinApp extends StatefulWidget {
  const BulletinApp({super.key});

  @override
  State<StatefulWidget> createState() => BulletinAppState();
}

class BulletinAppState extends State<BulletinApp> {
  @visibleForTesting
  late List<String> capturedImages = [];

  @override
  void initState() {
    super.initState();
    getCapturedImages();
  }

  void _navigateToMyApp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  void _navigateToCameraApp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraApp()),
    );
  }

@visibleForTesting
  Future<void> getCapturedImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      capturedImages = prefs.getStringList('captured_images') ?? [];
    });
  }

  

  List<Widget> buildImageWidgets() {
    return capturedImages.map((base64Image) {
      final imageBytes = base64Decode(base64Image);
      return LongPressDraggable(
        feedback: Image.memory(
          imageBytes,
          height: 200,
        ),
        childWhenDragging: Container(),
        child: Image.memory(imageBytes),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            
            Expanded(
              child: DragTarget<Widget>(builder: (context, imageBytes, height) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: capturedImages.length,
                  itemBuilder: (context, index) {
                    return null;                   
                  },
                );
              }),
            ),

            SizedBox(
              height: 100,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: buildImageWidgets()
                )
              
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () => _navigateToCameraApp(context),
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _navigateToMyApp(context),
            ),
          ],
        ),
      ),
    );
  }
}
