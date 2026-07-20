// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'BİST Maliyet Hesaplama Asistanı';

  @override
  String get splashBrand => 'BİST';

  @override
  String get splashCost => 'MALİYET';

  @override
  String get splashCalculation => 'HESAPLAMA';

  @override
  String get splashAssistant => 'ASİSTANI';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get update => 'Güncelle';

  @override
  String get yourPurchases => 'Alımlarınız';

  @override
  String get recordChip => 'Kayıt';

  @override
  String get addRow => 'Satır Ekle';

  @override
  String get newCalcStarted => 'Yeni hesap başlatıldı';

  @override
  String get enterAtLeastOnePurchase => 'Önce en az bir geçerli alım girin';

  @override
  String savedNamed(String name) {
    return '\"$name\" kaydedildi';
  }

  @override
  String get saveCalculation => 'Hesabı Kaydet';

  @override
  String get stockAccountName => 'Hisse / Hesap adı';

  @override
  String get stockAccountHint => 'Örn: THYAO';

  @override
  String get unnamed => 'Adsız';

  @override
  String get noRecordsForPdf => 'PDF oluşturulacak kayıt yok';

  @override
  String get savePdf => 'PDF\'i kaydet';

  @override
  String get pdfCreated => 'PDF oluşturuldu';

  @override
  String get pdfCreateFailed => 'PDF oluşturulamadı';

  @override
  String get createPdf => 'PDF Oluştur';

  @override
  String get pdfReportTitle => 'Maliyet Hesaplama Raporu';

  @override
  String pdfGeneratedAt(String date) {
    return 'Oluşturulma: $date';
  }

  @override
  String get drawerTitle => 'BİST Maliyet';

  @override
  String get drawerSubtitle => 'Hesaplama Asistanı';

  @override
  String get costReduction => 'Maliyet Düşürme';

  @override
  String get dividendCalculation => 'Temettü Hesaplama';

  @override
  String get profitLossSimulator => 'Kar/Zarar Simülatörü';

  @override
  String get savedCalculations => 'Kayıtlı Hesaplar';

  @override
  String get currencyLabel => 'Para Birimi';

  @override
  String get currencyTooltip => 'Para birimi';

  @override
  String get settings => 'Ayarlar';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get currencyTRYLabel => 'Türk Lirası';

  @override
  String get currencyUSDLabel => 'ABD Doları';

  @override
  String get currencyEURLabel => 'Euro';

  @override
  String get price => 'Fiyat';

  @override
  String get lot => 'Lot';

  @override
  String get amount => 'Tutar';

  @override
  String get deleteRow => 'Satırı sil';

  @override
  String get yourAverageCost => 'Ortalama Maliyetiniz';

  @override
  String get totalLots => 'Toplam Lot';

  @override
  String get totalAmount => 'Toplam Tutar';

  @override
  String get deleteConfirmTitle => 'Silinsin mi?';

  @override
  String deleteConfirmMessage(String name) {
    return '\"$name\" kalıcı olarak silinecek.';
  }

  @override
  String get noSavedYet => 'Henüz kayıtlı hesap yok';

  @override
  String get createAndSaveHint => 'Bir hesap oluşturup \"Kaydet\" deyin';

  @override
  String savedItemSubtitle(String avg, String qty, String date) {
    return 'Ort. $avg  •  $qty lot\n$date';
  }

  @override
  String get smartCostReduction => 'Akıllı Maliyet Düşürme';

  @override
  String get yourPositionInfo => 'Pozisyon Bilgileriniz';

  @override
  String get lotsYouHold => 'Elinizdeki Lot';

  @override
  String get hintThousand => 'Örn: 1.000';

  @override
  String get averageCost => 'Ortalama Maliyet';

  @override
  String get hintDecimal32 => 'Örn: 32,00';

  @override
  String get currentPrice => 'Güncel Fiyat';

  @override
  String get hintDecimal24 => 'Örn: 24,00';

  @override
  String get targetCost => 'Hedef Maliyet';

  @override
  String get hintDecimal28 => 'Örn: 28,00';

  @override
  String get result => 'Sonuç';

  @override
  String costReductionResult(String start, String newCost, String lots) {
    return 'Maliyetinizi $start\'den $newCost\'ye düşürmek için $lots lot daha almalısınız.';
  }

  @override
  String get additionalPurchaseAmount => 'Ek Alım Tutarı';

  @override
  String get newTotalLots => 'Yeni Toplam Lot';

  @override
  String get lotSuffix => 'lot';

  @override
  String get costReductionIncompleteInput =>
      'Hesaplama için tüm alanları doldurun. Elinizdeki lot, ortalama maliyet, güncel fiyat ve hedef maliyeti girin.';

  @override
  String get costReductionTargetNotLower =>
      'Hedef maliyet, mevcut ortalama maliyetinizden düşük olmalı. Maliyet düşürmek için daha düşük bir hedef belirleyin.';

  @override
  String get costReductionPriceNotBelowTarget =>
      'Güncel fiyat hedef maliyetin altında olmalı. Bu fiyattan alım yaparak ortalamanızı hedefe indiremezsiniz.';

  @override
  String get costReductionInfo =>
      'Hesaplama yalnızca alım maliyetini baz alır; komisyon, vergi ve fiyat dalgalanmaları dikkate alınmaz. Yatırım tavsiyesi değildir.';

  @override
  String get dividendInfoSection => 'Temettü Bilgileri';

  @override
  String get numberOfLots => 'Lot Sayısı';

  @override
  String get dividendPerShareGross => 'Hisse Başına Temettü (Brüt)';

  @override
  String get hintDecimal250 => 'Örn: 2,50';

  @override
  String get withholdingRate => 'Stopaj Oranı';

  @override
  String get hint15 => 'Örn: 15';

  @override
  String get sharePriceForYield => 'Hisse Fiyatı (Verim için)';

  @override
  String get netDividend => 'Net Temettü';

  @override
  String get grossDividend => 'Brüt Temettü';

  @override
  String get withholdingDeduction => 'Stopaj Kesintisi';

  @override
  String get yieldRate => 'Verim Oranı';

  @override
  String get dividendEmptyMessage =>
      'Hesaplama için lot sayısını ve hisse başına brüt temettüyü girin. Verim oranı için ayrıca hisse fiyatını da girebilirsiniz.';

  @override
  String get dividendInfoNote =>
      'Net temettü, brüt tutardan stopaj kesilerek bulunur. Türkiye\'de temettü stopajı güncel olarak %15\'tir. Verim oranı, hisse başına temettünün hisse fiyatına oranıdır. Yatırım tavsiyesi değildir.';

  @override
  String percentValue(String value) {
    return '%$value';
  }

  @override
  String get cost => 'Maliyet';

  @override
  String get hintDecimal35 => 'Örn: 35,00';

  @override
  String get profitLossEmptyMessage =>
      'Simülasyon için maliyet ve lot bilgisini girin. Ardından kaydırıcı ile fiyatı değiştirerek kar/zararınızı anlık görün.';

  @override
  String get profit => 'Kar';

  @override
  String get loss => 'Zarar';

  @override
  String get salePrice => 'Satış Fiyatı';

  @override
  String get costAmount => 'Maliyet Tutarı';

  @override
  String get positionValue => 'Pozisyon Değeri';

  @override
  String get profitLossChart => 'Kar/Zarar Grafiği';

  @override
  String breakEven(String value) {
    return 'Başabaş: $value';
  }

  @override
  String get profitLossInfoNote =>
      'Kar/zarar yalnızca (satış fiyatı − maliyet) × lot olarak hesaplanır; komisyon, vergi ve diğer masraflar dahil değildir. Yatırım tavsiyesi değildir.';

  @override
  String get updateAvailableTitle => 'Güncelleme Mevcut';

  @override
  String get updateAvailableBody =>
      'Yeni bir sürüm yayınlandı. Uygulamanızı yeniden yüklemeden güncelleyebilirsiniz. Kayıtlı hesaplamalarınız ve ayarlarınız korunur.';

  @override
  String get later => 'Daha Sonra';

  @override
  String get mandatoryUpdateTitle => 'Zorunlu Güncelleme';

  @override
  String get mandatoryUpdateBody =>
      'Bu sürüm artık desteklenmiyor. Uygulamayı kullanmaya devam etmek için güncellemeniz gerekiyor. Verileriniz korunur.';

  @override
  String get updateReadyTitle => 'Güncelleme Hazır';

  @override
  String get updateReadyBody =>
      'Güncelleme indirildi. Kurulumu tamamlamak için uygulamayı yeniden başlatın.';

  @override
  String get restart => 'Yeniden Başlat';

  @override
  String get updateDownloading => 'Güncelleme indiriliyor…';
}
