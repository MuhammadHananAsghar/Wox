import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3529879658404204/9706913489';
    } else if (Platform.isIOS) {
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3529879658404204/8010688433";
    } else if (Platform.isIOS) {
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
