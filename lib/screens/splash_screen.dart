import 'package:digital_wellbeing/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_wellbeing/screens/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (userSnapshot.hasData) {
              return const MyHomePage();
            }
            return const AuthScreen();
          },
        ),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            // Image.asset to display the PNG image as the logo
            Image.asset(
              'assets/images/logo2.png', // Replace 'assets/logo.png' with your actual image path
              width: 250,
              height: 250,
              color: Colors.white,

            ),
            SizedBox(height: 10),
            Center(
              child: SpinKitThreeBounce(
                color: Colors.white, // Color of the dots
                size: 40.0, // Size of the dots
              ),
            ),
          ],
        ),
      ),
    );
  }
}
