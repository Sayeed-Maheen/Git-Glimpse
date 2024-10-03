import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_app/utils/app_colors.dart';
import 'package:webview_app/controllers/splash_controller.dart';
// Import the controller

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    // Initialize the SplashController using Get.put()

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
