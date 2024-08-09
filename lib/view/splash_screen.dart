import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const screenRouteName = '/splash_screen';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      body: AnimatedSplashScreen(
        nextScreen: HomeScreen(),
        curve: Curves.bounceIn,
        backgroundColor: Colors.white,
        centered: false,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 3),
        splashIconSize: height,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/splash_pic.jpg',
                fit: BoxFit.cover, height: height * .6),
            SizedBox(height: height * 0.04),
            Text('TOP HEADLINES',
                style: GoogleFonts.anton(
                    letterSpacing: .6, color: Colors.grey.shade700)),
            SizedBox(height: height * 0.02),
            const SpinKitChasingDots(color: Colors.blue, size: 40),
          ],
        ),
        nextRoute: HomeScreen.screenRouteName,
      ),
    );
  }
}
