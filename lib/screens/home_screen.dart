import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_app/app_colors.dart';

import '../constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isWebPageLoaded = false;
  late InAppWebViewController inAppWebViewController;
  late ConnectivityResult _connectivityResult;
  late StreamSubscription<ConnectivityResult> subscription;

  final GlobalKey webViewKey = GlobalKey();
  PullToRefreshController? pullToRefreshController;

  bool pullToRefreshEnabled = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            //settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                inAppWebViewController.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                inAppWebViewController.loadUrl(
                    urlRequest:
                        URLRequest(url: await inAppWebViewController.getUrl()));
              }
            },
          );
  }

  Future<void> _initConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
      if (result == ConnectivityResult.none) {
        _showSnackbarWithRetry('No internet connection');
      }
    });
    if (_connectivityResult == ConnectivityResult.none) {
      _showSnackbarWithRetry('No internet connection');
    }
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  showExitPopup() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text(
            exit,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.colorBlack,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          contentPadding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 32,
            bottom: 24,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30.h,
                  width: 72.w,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: Center(
                      child: Text(
                        yes,
                        style: TextStyle(
                          color: AppColors.colorWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  height: 30.h,
                  width: 72.w,
                  decoration: BoxDecoration(
                    color: AppColors.colorWhite,
                    border: Border.all(width: 1.w, color: Colors.grey),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        no,
                        style: TextStyle(
                          color: AppColors.colorBlack,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(bottom: 32),
        );
      },
    );
  }

  Future<void> _retryInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });

    if (result != ConnectivityResult.none) {
      _showSnackbar('Internet connection restored');
    } else {
      _showSnackbarWithRetry('Failed to reconnect. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  late Completer<void> _retryCompleter;

  void _showSnackbarWithRetry(String message) {
    _retryCompleter = Completer<void>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[200],
        content: Text(
          message,
          style: const TextStyle(color: AppColors.colorBlack),
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          textColor: AppColors.colorStatusBar,
          label: retry,
          onPressed: () {
            _retryCompleter
                .complete(); // Complete the Completer when the retry button is pressed
            _retryInternetConnection(); // Retry the internet connection
          },
        ),
      ),
    );

    _retryCompleter.future.then((_) {
      // This callback will be triggered when the Completer is completed (i.e., when the user connects to the internet)
      ScaffoldMessenger.of(context)
          .removeCurrentSnackBar(); // Remove the current Snackbar
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectivityResult == ConnectivityResult.none) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColors.colorStatusBar,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        final isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        showExitPopup();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              if (_connectivityResult != ConnectivityResult.none)
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(webAppUrl),
                  ),

                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (InAppWebViewController controller) {
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      _isWebPageLoaded = true;
                    });
                    pullToRefreshController?.endRefreshing();
                  },
                  // onReceivedError: (controller, request, error) {
                  //   pullToRefreshController?.endRefreshing();
                  // },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                  },
                  initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                      initialScale: 100,
                      // useWideViewPort: true,
                      builtInZoomControls: false,
                      displayZoomControls: false,
                      scrollbarFadingEnabled: true,
                      overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER,
                    ),
                  ),
                ),
              if (!_isWebPageLoaded &&
                  _connectivityResult != ConnectivityResult.none)
                Center(
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppColors.colorWhite,
                      ),
                    ),
                  ),
                ),
              if (_connectivityResult == ConnectivityResult.none)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset("assets/images/no_internet.png"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          floatingActionButton: _connectivityResult != ConnectivityResult.none
              ? FloatingActionButton(
                  onPressed: () async {},
                  backgroundColor: AppColors.colorStatusBar,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: AppColors.colorWhite,
                    size: 25,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
