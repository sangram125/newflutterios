import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/models/user_account.dart';
import '../../injection/injection.dart';
import '../../widgets/appbar.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State createState() => _SupportWebViewState();
}

class _SupportWebViewState extends State<SupportView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    final cust = getIt<UserAccount>().customer;
    final String crmUrl;
    if (cust == null || cust.crmUrl.isEmpty) {
      getIt<UserAccount>().logout();
      crmUrl = "https://dorplay.crm.com/login";
    } else {
      crmUrl = cust.crmUrl;
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF010521))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.startsWith('https://dorplay.crm.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(crmUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }

  Future<bool> _backPressed() async {
    if (await controller.canGoBack()) {
      if (kDebugMode) {
        print("canGoBack");
      }
      controller.goBack();
      return Future.value(false);
    } else {
      if (kDebugMode) {
        print("cannotGoBack");
      }
      return Future.value(true);
    }
  }
}
