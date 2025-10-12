// main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paynest_mobile/screens/auth/welcome_screen.dart';
//import 'package:paynest_mobile/screens/home/home_shell.dart';
import 'package:paynest_mobile/theme/app_theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // --- This is the most important part ---
  // Ensure that plugin services are initialized before calling `runApp()`
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // Log the error to the console.
    // You can handle this more gracefully, e.g., show a dialog.
    print('Error initializing camera: ${e.code}\nError Message: ${e.description}');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayNest',
      theme: buildDarkTheme(),
      home: const WelcomeScreen(),
    );
  }
}