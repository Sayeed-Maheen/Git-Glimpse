import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:webview_app/controllers/home_controller.dart';
import 'package:webview_app/utils/app_colors.dart';
import 'package:webview_app/utils/constant.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: controller.onWillPop,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                if (controller.hasInternetConnection.value)
                  _buildWebView()
                else
                  _buildNoInternetWidget(),
                if (!controller.isWebPageLoaded.value &&
                    controller.hasInternetConnection.value)
                  _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWebView() {
    return InAppWebView(
      key: controller.webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(webAppUrl)),
      pullToRefreshController: controller.pullToRefreshController,
      onWebViewCreated: (InAppWebViewController webViewController) {
        controller.inAppWebViewController = webViewController;
      },
      onLoadStop: (_, __) {
        controller.isWebPageLoaded.value = true;
        controller.pullToRefreshController?.endRefreshing();
      },
      onProgressChanged: (_, progress) {
        if (progress == 100) {
          controller.pullToRefreshController?.endRefreshing();
        }
      },
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          initialScale: 100,
          builtInZoomControls: false,
          displayZoomControls: false,
          scrollbarFadingEnabled: true,
          overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER,
        ),
      ),
      onReceivedError: (controller, request, error) {
        // Handle WebView errors
        print("WebView Error: ${error.description}");
      },
      onConsoleMessage: (controller, consoleMessage) {
        // Log console messages for debugging
        print("Console Message: ${consoleMessage.message}");
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: AppColors.colorWhite),
        ),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset("assets/images/no_internet.png"),
          ),
        ],
      ),
    );
  }
}
