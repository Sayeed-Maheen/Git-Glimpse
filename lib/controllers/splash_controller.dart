import 'package:get/get.dart';
import 'package:webview_app/screens/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Wait for 3 seconds before navigating to the HomeScreen
    Future.delayed(const Duration(seconds: 3)).then((_) {
      Get.off(() => const HomeScreen());
    });
  }
}
