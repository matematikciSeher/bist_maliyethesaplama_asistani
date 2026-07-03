import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_version_utils.dart';
import 'app_update_config.dart';

class IosAppStoreInfo {
  const IosAppStoreInfo({
    required this.storeVersion,
    required this.storeUrl,
  });

  final String storeVersion;
  final String storeUrl;
}

class IosAppUpdateHandler {
  IosAppUpdateHandler._();

  static bool get isSupported => !kIsWeb && Platform.isIOS;

  static Future<IosAppStoreInfo?> fetchStoreInfo() async {
    final uri = Uri.https('itunes.apple.com', '/lookup', {
      'bundleId': AppUpdateConfig.iosBundleId,
      'country': 'tr',
    });

    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      if ((json['resultCount'] as int? ?? 0) == 0) return null;

      final result = (json['results'] as List).first as Map<String, dynamic>;
      final version = result['version'] as String?;
      if (version == null || version.isEmpty) return null;

      final storeUrl = _resolveStoreUrl(result);
      if (storeUrl == null) return null;

      return IosAppStoreInfo(storeVersion: version, storeUrl: storeUrl);
    } finally {
      client.close();
    }
  }

  static String? _resolveStoreUrl(Map<String, dynamic> result) {
    if (AppUpdateConfig.iosAppStoreId.isNotEmpty) {
      return 'https://apps.apple.com/app/id${AppUpdateConfig.iosAppStoreId}';
    }

    final trackViewUrl = result['trackViewUrl'] as String?;
    if (trackViewUrl != null && trackViewUrl.isNotEmpty) {
      return trackViewUrl;
    }

    final trackId = result['trackId'];
    if (trackId != null) {
      return 'https://apps.apple.com/app/id$trackId';
    }

    return null;
  }

  static Future<bool> isUpdateAvailable() async {
    final storeInfo = await fetchStoreInfo();
    if (storeInfo == null) return false;

    final packageInfo = await PackageInfo.fromPlatform();
    return compareVersions(storeInfo.storeVersion, packageInfo.version) > 0;
  }

  static bool isMandatoryUpdate(String storeVersion) {
    return isVersionAtLeast(storeVersion, AppUpdateConfig.mandatoryMinVersion);
  }

  static Future<void> openAppStore(String storeUrl) async {
    final uri = Uri.parse(storeUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw Exception('App Store açılamadı');
    }
  }
}
