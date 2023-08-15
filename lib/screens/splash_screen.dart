import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/app_colors.dart';
import 'package:webview_app/screens/home_screen.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Widget _initialScreen;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _determineInitialScreen();
    });
  }

  void _determineInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding =
        prefs.getBool('has_completed_onboarding') ?? false;

    if (!hasCompletedOnboarding) {
      //New Onboarding
      setState(() {
        _initialScreen = const OnboardingScreen();
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _initialScreen),
      );
    } else {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.colorGradientStart,
              AppColors.colorGradientMiddle,
              AppColors.colorGradientEnd
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(36),
              child: Image.asset(
                'assets/images/logo.png'

              ),
            ),
          ],
        ),
      ),
    );
  }
}
