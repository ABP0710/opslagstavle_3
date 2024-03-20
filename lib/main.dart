import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opslagstavle_3/bloc/state/bulletin_board_state.dart';
import 'package:opslagstavle_3/bloc/state/camera_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:opslagstavle_3/notifikations/notifikation_service.dart';

import 'firebase_options.dart';

late List<CameraDescription> cameras;
// ...
final MyNotification notify = MyNotification();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FcmToken $fcmToken');
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    }
    cameras = await availableCameras();
    notify.myNotificationInit();
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error $e');
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  debugPrint("Dette sker i baggrunden: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opslagstavle',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Opslagstavle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Velkommen til din nye foto opslagstagle',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
              icon: const Icon(Icons.picture_in_picture_alt_outlined),
              onPressed: () => _navigateToBulletinApp(context),
            ),
          ],
        ),
      ),
    );
  }
}

void _navigateToCameraApp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CameraApp()),
  );
}

void _navigateToBulletinApp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const BulletinApp()),
  );
}
