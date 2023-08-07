import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/config.dart';
import 'package:omni_k/main.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  HttpOverrides.global = NoCheckCertificateHttpOverrides();
  MobileAds.instance.initialize();

  // << RUN >> //
  runApp(
    const ProviderScope(
      child: Init(),
      // child: Test(),
    ),
  );
}

class Init extends HookConsumerWidget {
  const Init({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("<<Processing>> Init");

    // Initially Create -> Local Directory for Saving Data
    // [ /data/user/0/com.example.omni_k/app_flutter ]
    initConfig(ref);

    return MaterialApp(
      home: const WillPopScope(  // AOS 의 하단 뒤로가기 버튼 방지
        onWillPop: null,
        child: SplashScreen(),
      ),
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? MyTheme.kIOSTheme
        : MyTheme.kDefaultTheme,
      routes: {
        '/main' : (BuildContext context) => const OmniK(),
      },
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(switchDarkmode) ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

