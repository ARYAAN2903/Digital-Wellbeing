import 'package:digital_wellbeing/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home.dart';
import 'package:digital_wellbeing/service/event_stats/event_stats.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Wellbeing',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 224, 247, 250),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
