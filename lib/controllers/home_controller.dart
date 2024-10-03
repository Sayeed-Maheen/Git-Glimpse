import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_app/utils/app_colors.dart';
import 'package:webview_app/utils/constant.dart';

class HomeController extends GetxController {
  final isWebPageLoaded = false.obs;
  final hasInternetConnection = true.obs;
  late InAppWebViewController inAppWebViewController;
  final GlobalKey webViewKey = GlobalKey();
  PullToRefreshController? pullToRefreshController;
  Timer? _connectivityTimer;

  @override
  void onInit() {
    super.onInit();
    _initPullToRefresh();
    _initWebViewLogs();
    _startPeriodicConnectivityCheck();
  }

  void _initPullToRefresh() {
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (GetPlatform.isAndroid) {
          inAppWebViewController.reload();
        } else if (GetPlatform.isIOS) {
          inAppWebViewController.loadUrl(
            urlRequest: URLRequest(url: await inAppWebViewController.getUrl()),
          );
        }
      },
    );
  }

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer =
        Timer.periodic(Duration(seconds: 5), (_) => _checkConnectivity());
  }

  Future<void> _checkConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool isConnected = connectivityResult != ConnectivityResult.none;

      if (hasInternetConnection.value != isConnected) {
        hasInternetConnection.value = isConnected;
        if (isConnected) {
          await Future.delayed(
              Duration(seconds: 2)); // Wait a bit before reloading
          inAppWebViewController.reload();
        }
      }
    } catch (e) {
      print('Error checking connectivity: $e');
      hasInternetConnection.value = false;
    }
  }

  void _initWebViewLogs() {
    if (GetPlatform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  Future<bool> onWillPop() async {
    final isLastPage = await inAppWebViewController.canGoBack();
    if (isLastPage) {
      inAppWebViewController.goBack();
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    _connectivityTimer?.cancel();
    super.onClose();
  }
}
