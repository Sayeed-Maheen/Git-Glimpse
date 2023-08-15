import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/screens/home_screen.dart';

import '../app_colors.dart';

import '../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(

        body: Container(
          height: double.infinity,
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
          child: Stack(alignment: Alignment.center, children: [
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return true;
              },
              child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: contents.length,
                  itemBuilder: (_, i) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          Text(
                            contents[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.colorWhite,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              contents[i].discription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.colorWhite,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 110.h),
                          Image.asset(
                            contents[i].image,
                            height: 353.h,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Positioned(
              bottom: 30.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
            Positioned(
              top: 180.h,
              child: Visibility(
                visible: currentIndex == contents.length - 1,
                replacement: Container(
                  height: 52.h,
                  width: 58.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.colorBlack,
                  ),
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.colorWhite,
                    ),
                  ),
                ),
                child: Container(
                  height: 50.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    color: AppColors.colorBlack,
                  ),
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      if (currentIndex == contents.length - 1) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('has_completed_onboarding', true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()));
                      }
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Text(
                      "Let's Start",
                      style: TextStyle(
                        color: AppColors.colorWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
        height: currentIndex == index ? 7.h : 3.h,
        margin: const EdgeInsets.all(3),
        width: currentIndex == index ? 24.w : 24.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: currentIndex == index
              ? AppColors.colorBlack
              : AppColors.colorWhite,
        ));
  }
}
