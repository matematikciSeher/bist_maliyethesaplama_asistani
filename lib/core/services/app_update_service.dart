import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/app_version_utils.dart';
import 'app_update_config.dart';
import 'ios_app_update_handler.dart';

/// Android (Play In-App Update) ve iOS (App Store) güncelleme akışı.
///
/// Güncelleme mevcut verileri silmez; uygulama üzerine yazılır.
class AppUpdateService {
  AppUpdateService._();

  static bool get isAndroidSupported => !kIsWeb && Platform.isAndroid;
  static bool get isIosSupported => IosAppUpdateHandler.isSupported;
  static bool get isSupported => isAndroidSupported || isIosSupported;

  static Future<void> checkAndPrompt(BuildContext context) async {
    if (!isSupported) return;

    if (isAndroidSupported) {
      await _checkAndroidUpdate(context);
      return;
    }

    if (isIosSupported) {
      await _checkIosUpdate(context);
    }
  }

  static Future<void> _checkAndroidUpdate(BuildContext context) async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (!context.mounted) return;

      if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        if (info.installStatus == InstallStatus.downloaded) {
          await showRestartDialog(context);
        }
        return;
      }

      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      final mandatory = _isMandatoryAndroidUpdate(info);
      if (!context.mounted) return;
      final shouldUpdate = mandatory
          ? await showMandatoryUpdateDialog(context)
          : await showUpdateDialog(context);
      if (shouldUpdate != true || !context.mounted) return;

      await _performAndroidUpdate(context, info, mandatory: mandatory);
    } catch (_) {
      // Play Store dışı kurulum veya debug ortamında sessizce geçilir.
    }
  }

  static Future<void> _checkIosUpdate(BuildContext context) async {
    try {
      final storeInfo = await IosAppUpdateHandler.fetchStoreInfo();
      if (storeInfo == null || !context.mounted) return;

      final packageInfo = await PackageInfo.fromPlatform();
      if (compareVersions(storeInfo.storeVersion, packageInfo.version) <= 0) {
        return;
      }

      final mandatory = IosAppUpdateHandler.isMandatoryUpdate(
        storeInfo.storeVersion,
      );
      if (!context.mounted) return;
      final shouldUpdate = mandatory
          ? await showMandatoryUpdateDialog(context)
          : await showUpdateDialog(context);
      if (shouldUpdate != true || !context.mounted) return;

      await IosAppUpdateHandler.openAppStore(storeInfo.storeUrl);
    } catch (_) {
      // Ağ hatası veya App Store erişim sorununda sessizce geçilir.
    }
  }

  static bool _isMandatoryAndroidUpdate(AppUpdateInfo info) {
    if (info.updatePriority >= AppUpdateConfig.mandatoryUpdatePriority) {
      return true;
    }

    final availableCode = info.availableVersionCode;
    if (availableCode != null &&
        AppUpdateConfig.mandatoryMinVersionCode > 0 &&
        availableCode >= AppUpdateConfig.mandatoryMinVersionCode) {
      return true;
    }

    return false;
  }

  static Future<bool?> showUpdateDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.system_update_alt_rounded),
        title: const Text('Güncelleme Mevcut'),
        content: const Text(
          'Yeni bir sürüm yayınlandı. Uygulamanızı yeniden yüklemeden '
          'güncelleyebilirsiniz. Kayıtlı hesaplamalarınız ve ayarlarınız '
          'korunur.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Daha Sonra'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showMandatoryUpdateDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded),
          title: const Text('Zorunlu Güncelleme'),
          content: const Text(
            'Bu sürüm artık desteklenmiyor. Uygulamayı kullanmaya devam '
            'etmek için güncellemeniz gerekiyor. Verileriniz korunur.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showRestartDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.download_done_rounded),
        title: const Text('Güncelleme Hazır'),
        content: const Text(
          'Güncelleme indirildi. Kurulumu tamamlamak için uygulamayı '
          'yeniden başlatın.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              InAppUpdate.completeFlexibleUpdate();
            },
            child: const Text('Yeniden Başlat'),
          ),
        ],
      ),
    );
  }

  static Future<void> _performAndroidUpdate(
    BuildContext context,
    AppUpdateInfo info, {
    required bool mandatory,
  }) async {
    if (mandatory && info.immediateUpdateAllowed) {
      await InAppUpdate.performImmediateUpdate();
      return;
    }

    if (info.flexibleUpdateAllowed) {
      final result = await InAppUpdate.startFlexibleUpdate();
      if (result == AppUpdateResult.success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Güncelleme indiriliyor…'),
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    if (info.immediateUpdateAllowed) {
      await InAppUpdate.performImmediateUpdate();
    }
  }

  static StreamSubscription<InstallStatus>? listenForDownload(
    void Function(InstallStatus status) onStatus,
  ) {
    if (!isAndroidSupported) return null;
    return InAppUpdate.installUpdateListener.listen(onStatus);
  }
}
