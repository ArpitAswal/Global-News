import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repository/news_repository.dart';
import '../utils/preference_data/news_preference.dart';
import 'all_news_views/headlines_news_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const screenRouteName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() async {
    await NewsPreference().initialize();
    Get.putAsync<NewsRepository>(() => NewsRepository.create(),
        permanent:
            true); // ensures NewsRepository is fully initialized before being used
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      body: AnimatedSplashScreen(
        nextScreen: HeadlinesNewsScreen(),
        curve: Curves.bounceIn,
        backgroundColor: Colors.white,
        centered: false,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 3),
        splashIconSize: height,
        nextRoute: HeadlinesNewsScreen.screenRouteName,
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
      ),
    );
  }
}
