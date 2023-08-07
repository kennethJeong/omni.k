import 'dart:io';
import 'package:flutter_config/flutter_config.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return FlutterConfig.get('admob_aos_unitId_banner');
    } else if (Platform.isIOS) {
      return FlutterConfig.get('admob_ios_unitId_banner');
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return FlutterConfig.get('admob_aos_unitId_native');
    } else if (Platform.isIOS) {
      return FlutterConfig.get('admob_ios_unitId_native');
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return FlutterConfig.get('admob_aos_unitId_interstitial');
    } else if (Platform.isIOS) {
      return FlutterConfig.get('admob_ios_unitId_interstitial');
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}