import 'dart:io';

import 'package:flutter/foundation.dart';

/// AdMob reklam kimlikleri ve yardımcıları.
///
/// Debug modunda Google'ın resmi test reklam birimleri kullanılır; böylece
/// geliştirme sırasında gerçek reklamlara tıklanıp hesabın askıya alınması
/// önlenir. Release modunda gerçek reklam birimleri devreye girer.
class AdConfig {
  AdConfig._();

  /// Google'ın resmi test banner reklam birimleri.
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBanneriOS =
      'ca-app-pub-3940256099942544/2934735716';

  /// Gerçek (production) banner reklam birimleri.
  static const String _prodBannerAndroid =
      'ca-app-pub-7068164541011250/6791501561';
  static const String _prodBanneriOS =
      'ca-app-pub-7068164541011250/4034164644';

  /// Platforma ve derleme moduna göre banner reklam birimi kimliği.
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode ? _prodBannerAndroid : _testBannerAndroid;
    }
    if (Platform.isIOS) {
      return kReleaseMode ? _prodBanneriOS : _testBanneriOS;
    }
    return _testBannerAndroid;
  }
}
