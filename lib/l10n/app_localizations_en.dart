// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BIST Cost Calculation Assistant';

  @override
  String get splashBrand => 'BIST';

  @override
  String get splashCost => 'COST';

  @override
  String get splashCalculation => 'CALCULATION';

  @override
  String get splashAssistant => 'ASSISTANT';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get update => 'Update';

  @override
  String get yourPurchases => 'Your Purchases';

  @override
  String get recordChip => 'Record';

  @override
  String get addRow => 'Add Row';

  @override
  String get newCalcStarted => 'New calculation started';

  @override
  String get enterAtLeastOnePurchase =>
      'Enter at least one valid purchase first';

  @override
  String savedNamed(String name) {
    return '\"$name\" saved';
  }

  @override
  String get saveCalculation => 'Save Calculation';

  @override
  String get stockAccountName => 'Stock / Account name';

  @override
  String get stockAccountHint => 'e.g. THYAO';

  @override
  String get unnamed => 'Unnamed';

  @override
  String get noRecordsForPdf => 'No records to create a PDF';

  @override
  String get savePdf => 'Save PDF';

  @override
  String get pdfCreated => 'PDF created';

  @override
  String get pdfCreateFailed => 'PDF could not be created';

  @override
  String get createPdf => 'Create PDF';

  @override
  String get pdfReportTitle => 'Cost Calculation Report';

  @override
  String pdfGeneratedAt(String date) {
    return 'Generated: $date';
  }

  @override
  String get drawerTitle => 'BIST Cost';

  @override
  String get drawerSubtitle => 'Calculation Assistant';

  @override
  String get costReduction => 'Cost Reduction';

  @override
  String get dividendCalculation => 'Dividend Calculation';

  @override
  String get profitLossSimulator => 'Profit/Loss Simulator';

  @override
  String get savedCalculations => 'Saved Calculations';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get currencyTooltip => 'Currency';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get currencyTRYLabel => 'Turkish Lira';

  @override
  String get currencyUSDLabel => 'US Dollar';

  @override
  String get currencyEURLabel => 'Euro';

  @override
  String get price => 'Price';

  @override
  String get lot => 'Lot';

  @override
  String get amount => 'Amount';

  @override
  String get deleteRow => 'Delete row';

  @override
  String get yourAverageCost => 'Your Average Cost';

  @override
  String get totalLots => 'Total Lots';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String deleteConfirmMessage(String name) {
    return '\"$name\" will be permanently deleted.';
  }

  @override
  String get noSavedYet => 'No saved calculations yet';

  @override
  String get createAndSaveHint => 'Create a calculation and tap \"Save\"';

  @override
  String savedItemSubtitle(String avg, String qty, String date) {
    return 'Avg. $avg  •  $qty lot\n$date';
  }

  @override
  String get smartCostReduction => 'Smart Cost Reduction';

  @override
  String get yourPositionInfo => 'Your Position Info';

  @override
  String get lotsYouHold => 'Lots You Hold';

  @override
  String get hintThousand => 'e.g. 1,000';

  @override
  String get averageCost => 'Average Cost';

  @override
  String get hintDecimal32 => 'e.g. 32.00';

  @override
  String get currentPrice => 'Current Price';

  @override
  String get hintDecimal24 => 'e.g. 24.00';

  @override
  String get targetCost => 'Target Cost';

  @override
  String get hintDecimal28 => 'e.g. 28.00';

  @override
  String get result => 'Result';

  @override
  String costReductionResult(String start, String newCost, String lots) {
    return 'To lower your cost from $start to $newCost, you should buy $lots more lots.';
  }

  @override
  String get additionalPurchaseAmount => 'Additional Purchase';

  @override
  String get newTotalLots => 'New Total Lots';

  @override
  String get lotSuffix => 'lot';

  @override
  String get costReductionIncompleteInput =>
      'Fill in all fields to calculate. Enter the lots you hold, your average cost, the current price and the target cost.';

  @override
  String get costReductionTargetNotLower =>
      'The target cost must be lower than your current average cost. Set a lower target to reduce your cost.';

  @override
  String get costReductionPriceNotBelowTarget =>
      'The current price must be below the target cost. You cannot bring your average down to the target by buying at this price.';

  @override
  String get costReductionInfo =>
      'The calculation is based only on purchase cost; commissions, taxes and price fluctuations are not taken into account. This is not investment advice.';

  @override
  String get dividendInfoSection => 'Dividend Info';

  @override
  String get numberOfLots => 'Number of Lots';

  @override
  String get dividendPerShareGross => 'Dividend per Share (Gross)';

  @override
  String get hintDecimal250 => 'e.g. 2.50';

  @override
  String get withholdingRate => 'Withholding Rate';

  @override
  String get hint15 => 'e.g. 15';

  @override
  String get sharePriceForYield => 'Share Price (for yield)';

  @override
  String get netDividend => 'Net Dividend';

  @override
  String get grossDividend => 'Gross Dividend';

  @override
  String get withholdingDeduction => 'Withholding';

  @override
  String get yieldRate => 'Yield Rate';

  @override
  String get dividendEmptyMessage =>
      'Enter the number of lots and the gross dividend per share to calculate. You can also enter the share price to see the yield.';

  @override
  String get dividendInfoNote =>
      'Net dividend is found by deducting withholding tax from the gross amount. In Türkiye the dividend withholding tax is currently 15%. The yield is the ratio of the dividend per share to the share price. This is not investment advice.';

  @override
  String percentValue(String value) {
    return '$value%';
  }

  @override
  String get cost => 'Cost';

  @override
  String get hintDecimal35 => 'e.g. 35.00';

  @override
  String get profitLossEmptyMessage =>
      'Enter the cost and lot info to run the simulation. Then move the slider to change the price and see your profit/loss instantly.';

  @override
  String get profit => 'Profit';

  @override
  String get loss => 'Loss';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get costAmount => 'Cost Amount';

  @override
  String get positionValue => 'Position Value';

  @override
  String get profitLossChart => 'Profit/Loss Chart';

  @override
  String breakEven(String value) {
    return 'Break-even: $value';
  }

  @override
  String get profitLossInfoNote =>
      'Profit/loss is calculated only as (sale price − cost) × lots; commissions, taxes and other costs are not included. This is not investment advice.';

  @override
  String get updateAvailableTitle => 'Update Available';

  @override
  String get updateAvailableBody =>
      'A new version has been released. You can update without reinstalling the app. Your saved calculations and settings are preserved.';

  @override
  String get later => 'Later';

  @override
  String get mandatoryUpdateTitle => 'Mandatory Update';

  @override
  String get mandatoryUpdateBody =>
      'This version is no longer supported. You need to update to keep using the app. Your data is preserved.';

  @override
  String get updateReadyTitle => 'Update Ready';

  @override
  String get updateReadyBody =>
      'The update has been downloaded. Restart the app to complete the installation.';

  @override
  String get restart => 'Restart';

  @override
  String get updateDownloading => 'Downloading update…';
}
