/// Uygulama güncelleme davranışı ayarları.
///
/// Kritik bir sürüm yayınlarken [mandatoryMinVersionCode] ve/veya
/// [mandatoryMinVersion] değerlerini yeni sürümle güncelleyin.
class AppUpdateConfig {
  AppUpdateConfig._();

  /// Play Console'da `updatePriority` bu değere eşit veya büyükse zorunlu güncelleme.
  static const int mandatoryUpdatePriority = 4;

  /// Play Store sürüm kodu (versionCode) bu değere eşit veya büyükse zorunlu güncelleme.
  /// `0` = devre dışı. Kritik yayın öncesi yeni versionCode ile güncelleyin.
  static const int mandatoryMinVersionCode = 0;

  /// App Store sürümü bu değere eşit veya büyükse zorunlu güncelleme.
  /// Boş = devre dışı. Örnek: `'1.0.1'`
  static const String mandatoryMinVersion = '';

  static const String iosBundleId = 'net.bistmaliyet.bistMaliyetAsistani';

  /// App Store uygulama ID'si (sayısal). Boşsa iTunes API'den alınır.
  static const String iosAppStoreId = '';
}
