import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_app/app_colors.dart';
import 'package:webview_app/screens/home_screen.dart';

import '../constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSplashScreen,
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Image.asset("assets/images/splashLogo.png",
              height: 200.h, width: 200.w),
        ),
      ),
    );
  }
}
