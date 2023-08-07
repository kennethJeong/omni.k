// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:omni_k/app_theme.dart';

class PTest extends HookConsumerWidget {
  PTest({super.key, required this.heightPTest});

  final double heightPTest;

  final PageController pageController = PageController(
    viewportFraction: 1.0,
    keepPage: true,
  );

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions webViewGroupOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      javaScriptCanOpenWindowsAutomatically: true,
      javaScriptEnabled: true,
      useOnDownloadStart: true,
      useOnLoadResource: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      verticalScrollBarEnabled: true,
      cacheEnabled: true,
      // userAgent: 'random',
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      allowContentAccess: true,
      builtInZoomControls: true,
      thirdPartyCookiesEnabled: true,
      allowFileAccess: true,
      supportMultipleWindows: true,
    ),
    ios: IOSInAppWebViewOptions(

    ),
  );

  PullToRefreshController? pullToRefreshController;
  double progress = 0;
  double heightTitle = 50;


  ////////////////////////////////////////////////////////////////////////////////
  Map<String, String> listTestView(BuildContext context) {
    return {
      // 'Naver': 'https://www.naver.com',
      'MBTI': 'https://www.xpersonalitytest.com/vi/free-personality-test',
      'HEXACO': 'https://survey.ucalgary.ca/jfe/form/SV_0icFBjWwyHvJOfA',
    };
  }
  ////////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    pullToRefreshController = (kIsWeb
      ? null
      : PullToRefreshController(
        options: PullToRefreshOptions(
          color: MyTheme.kPrimaryColor,
          size: AndroidPullToRefreshSize.LARGE,
          distanceToTriggerSync: 200,
          slingshotDistance: 500,
        ),
        onRefresh: () async {
          if (defaultTargetPlatform == TargetPlatform.android) {
            webViewController?.reload();
          } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
            webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: await webViewController?.getUrl()
              )
            );
          }
        },
      )
    );

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return PageView.builder(
                controller: pageController,
                onPageChanged: (_) {
                  ref.read(check_swipe_webview.notifier).state = true;
                  Timer(const Duration(milliseconds: 2000), () {
                    ref.read(check_swipe_webview.notifier).state = false;
                  });
                },
                itemCount: listTestView(context).length,
                itemBuilder: (context, index) {
                  String title = listTestView(context).keys.elementAt(index);
                  String url = listTestView(context).values.elementAt(index);

                  return SingleChildScrollView(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Stack(
                        children: [
                          InAppWebView(
                            initialOptions: webViewGroupOptions,
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                            },
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(url),
                            ),
                            onScrollChanged: (controller, x, y) {
                              if (y == 0) {
                                ref.read(check_scroll_webview.notifier).state = false;
                              } else {
                                ref.read(check_scroll_webview.notifier).state = true;
                              }
                            },
                            gestureRecognizers: Set()..add(
                              Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()
                              ),
                            ),
                            pullToRefreshController: pullToRefreshController,
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
                                pullToRefreshController?.endRefreshing();
                              }
                              this.progress = progress / 100;
                            },
                            onReceivedServerTrustAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge challenge) async {
                              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                            },
                          ),
                          !ref.watch(check_scroll_webview) ? Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: heightTitle,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: MyTheme.kAccentColor,
                                  ),
                                ),
                              ),
                            ),
                          ) : const SizedBox.shrink(),
                          ref.watch(check_swipe_webview) ? Container(
                            color: Colors.white12.withOpacity(0.7),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  );
                },
              );
            }
          ),
        ),

        // smooth_page_indicator
        //
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5),
          child: SmoothPageIndicator(
            controller: pageController,
            count: listTestView(context).length,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                width: 12,
                height: 5,
                color: MyTheme.kPrimaryColorVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              dotDecoration: DotDecoration(
                width: 12,
                height: 3,
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              spacing: 6.0,
            ),
          ),
        ),
      ],
    );
  }
}