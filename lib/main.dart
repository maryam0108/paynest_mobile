// main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paynest_mobile/screens/auth/splash_screen.dart';
// import 'package:paynest_mobile/screens/auth/welcome_screen.dart';
//import 'package:paynest_mobile/screens/home/home_shell.dart';
import 'package:paynest_mobile/theme/app_theme.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
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
      home: const SplashScreen(),
    );
  }
}