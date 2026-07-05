import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BIST Cost Calculation Assistant'**
  String get appTitle;

  /// No description provided for @splashBrand.
  ///
  /// In en, this message translates to:
  /// **'BIST'**
  String get splashBrand;

  /// No description provided for @splashCost.
  ///
  /// In en, this message translates to:
  /// **'COST'**
  String get splashCost;

  /// No description provided for @splashCalculation.
  ///
  /// In en, this message translates to:
  /// **'CALCULATION'**
  String get splashCalculation;

  /// No description provided for @splashAssistant.
  ///
  /// In en, this message translates to:
  /// **'ASSISTANT'**
  String get splashAssistant;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @yourPurchases.
  ///
  /// In en, this message translates to:
  /// **'Your Purchases'**
  String get yourPurchases;

  /// No description provided for @recordChip.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get recordChip;

  /// No description provided for @addRow.
  ///
  /// In en, this message translates to:
  /// **'Add Row'**
  String get addRow;

  /// No description provided for @newCalcStarted.
  ///
  /// In en, this message translates to:
  /// **'New calculation started'**
  String get newCalcStarted;

  /// No description provided for @enterAtLeastOnePurchase.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one valid purchase first'**
  String get enterAtLeastOnePurchase;

  /// No description provided for @savedNamed.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" saved'**
  String savedNamed(String name);

  /// No description provided for @saveCalculation.
  ///
  /// In en, this message translates to:
  /// **'Save Calculation'**
  String get saveCalculation;

  /// No description provided for @stockAccountName.
  ///
  /// In en, this message translates to:
  /// **'Stock / Account name'**
  String get stockAccountName;

  /// No description provided for @stockAccountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. THYAO'**
  String get stockAccountHint;

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// No description provided for @noRecordsToExport.
  ///
  /// In en, this message translates to:
  /// **'No records to export'**
  String get noRecordsToExport;

  /// No description provided for @saveBackup.
  ///
  /// In en, this message translates to:
  /// **'Save backup'**
  String get saveBackup;

  /// No description provided for @backupExported.
  ///
  /// In en, this message translates to:
  /// **'Backup exported'**
  String get backupExported;

  /// No description provided for @selectBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Select backup file'**
  String get selectBackupFile;

  /// No description provided for @recordsImported.
  ///
  /// In en, this message translates to:
  /// **'{count} records imported'**
  String recordsImported(int count);

  /// No description provided for @fileUnreadable.
  ///
  /// In en, this message translates to:
  /// **'File could not be read or is invalid'**
  String get fileUnreadable;

  /// No description provided for @drawerTitle.
  ///
  /// In en, this message translates to:
  /// **'BIST Cost'**
  String get drawerTitle;

  /// No description provided for @drawerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation Assistant'**
  String get drawerSubtitle;

  /// No description provided for @costReduction.
  ///
  /// In en, this message translates to:
  /// **'Cost Reduction'**
  String get costReduction;

  /// No description provided for @dividendCalculation.
  ///
  /// In en, this message translates to:
  /// **'Dividend Calculation'**
  String get dividendCalculation;

  /// No description provided for @profitLossSimulator.
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss Simulator'**
  String get profitLossSimulator;

  /// No description provided for @savedCalculations.
  ///
  /// In en, this message translates to:
  /// **'Saved Calculations'**
  String get savedCalculations;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newItem;

  /// No description provided for @exportItem.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportItem;

  /// No description provided for @importItem.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importItem;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @currencyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyTooltip;

  /// No description provided for @currencyTRYLabel.
  ///
  /// In en, this message translates to:
  /// **'Turkish Lira'**
  String get currencyTRYLabel;

  /// No description provided for @currencyUSDLabel.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get currencyUSDLabel;

  /// No description provided for @currencyEURLabel.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currencyEURLabel;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @deleteRow.
  ///
  /// In en, this message translates to:
  /// **'Delete row'**
  String get deleteRow;

  /// No description provided for @yourAverageCost.
  ///
  /// In en, this message translates to:
  /// **'Your Average Cost'**
  String get yourAverageCost;

  /// No description provided for @totalLots.
  ///
  /// In en, this message translates to:
  /// **'Total Lots'**
  String get totalLots;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be permanently deleted.'**
  String deleteConfirmMessage(String name);

  /// No description provided for @noSavedYet.
  ///
  /// In en, this message translates to:
  /// **'No saved calculations yet'**
  String get noSavedYet;

  /// No description provided for @createAndSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Create a calculation and tap \"Save\"'**
  String get createAndSaveHint;

  /// No description provided for @savedItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Avg. {avg}  •  {qty} lot\n{date}'**
  String savedItemSubtitle(String avg, String qty, String date);

  /// No description provided for @smartCostReduction.
  ///
  /// In en, this message translates to:
  /// **'Smart Cost Reduction'**
  String get smartCostReduction;

  /// No description provided for @yourPositionInfo.
  ///
  /// In en, this message translates to:
  /// **'Your Position Info'**
  String get yourPositionInfo;

  /// No description provided for @lotsYouHold.
  ///
  /// In en, this message translates to:
  /// **'Lots You Hold'**
  String get lotsYouHold;

  /// No description provided for @hintThousand.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1,000'**
  String get hintThousand;

  /// No description provided for @averageCost.
  ///
  /// In en, this message translates to:
  /// **'Average Cost'**
  String get averageCost;

  /// No description provided for @hintDecimal32.
  ///
  /// In en, this message translates to:
  /// **'e.g. 32.00'**
  String get hintDecimal32;

  /// No description provided for @currentPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Price'**
  String get currentPrice;

  /// No description provided for @hintDecimal24.
  ///
  /// In en, this message translates to:
  /// **'e.g. 24.00'**
  String get hintDecimal24;

  /// No description provided for @targetCost.
  ///
  /// In en, this message translates to:
  /// **'Target Cost'**
  String get targetCost;

  /// No description provided for @hintDecimal28.
  ///
  /// In en, this message translates to:
  /// **'e.g. 28.00'**
  String get hintDecimal28;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @costReductionResult.
  ///
  /// In en, this message translates to:
  /// **'To lower your cost from {start} to {newCost}, you should buy {lots} more lots.'**
  String costReductionResult(String start, String newCost, String lots);

  /// No description provided for @additionalPurchaseAmount.
  ///
  /// In en, this message translates to:
  /// **'Additional Purchase'**
  String get additionalPurchaseAmount;

  /// No description provided for @newTotalLots.
  ///
  /// In en, this message translates to:
  /// **'New Total Lots'**
  String get newTotalLots;

  /// No description provided for @lotSuffix.
  ///
  /// In en, this message translates to:
  /// **'lot'**
  String get lotSuffix;

  /// No description provided for @costReductionIncompleteInput.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields to calculate. Enter the lots you hold, your average cost, the current price and the target cost.'**
  String get costReductionIncompleteInput;

  /// No description provided for @costReductionTargetNotLower.
  ///
  /// In en, this message translates to:
  /// **'The target cost must be lower than your current average cost. Set a lower target to reduce your cost.'**
  String get costReductionTargetNotLower;

  /// No description provided for @costReductionPriceNotBelowTarget.
  ///
  /// In en, this message translates to:
  /// **'The current price must be below the target cost. You cannot bring your average down to the target by buying at this price.'**
  String get costReductionPriceNotBelowTarget;

  /// No description provided for @costReductionInfo.
  ///
  /// In en, this message translates to:
  /// **'The calculation is based only on purchase cost; commissions, taxes and price fluctuations are not taken into account. This is not investment advice.'**
  String get costReductionInfo;

  /// No description provided for @dividendInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Dividend Info'**
  String get dividendInfoSection;

  /// No description provided for @numberOfLots.
  ///
  /// In en, this message translates to:
  /// **'Number of Lots'**
  String get numberOfLots;

  /// No description provided for @dividendPerShareGross.
  ///
  /// In en, this message translates to:
  /// **'Dividend per Share (Gross)'**
  String get dividendPerShareGross;

  /// No description provided for @hintDecimal250.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2.50'**
  String get hintDecimal250;

  /// No description provided for @withholdingRate.
  ///
  /// In en, this message translates to:
  /// **'Withholding Rate'**
  String get withholdingRate;

  /// No description provided for @hint15.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get hint15;

  /// No description provided for @sharePriceForYield.
  ///
  /// In en, this message translates to:
  /// **'Share Price (for yield)'**
  String get sharePriceForYield;

  /// No description provided for @netDividend.
  ///
  /// In en, this message translates to:
  /// **'Net Dividend'**
  String get netDividend;

  /// No description provided for @grossDividend.
  ///
  /// In en, this message translates to:
  /// **'Gross Dividend'**
  String get grossDividend;

  /// No description provided for @withholdingDeduction.
  ///
  /// In en, this message translates to:
  /// **'Withholding'**
  String get withholdingDeduction;

  /// No description provided for @yieldRate.
  ///
  /// In en, this message translates to:
  /// **'Yield Rate'**
  String get yieldRate;

  /// No description provided for @dividendEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of lots and the gross dividend per share to calculate. You can also enter the share price to see the yield.'**
  String get dividendEmptyMessage;

  /// No description provided for @dividendInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Net dividend is found by deducting withholding tax from the gross amount. In Türkiye the dividend withholding tax is currently 15%. The yield is the ratio of the dividend per share to the share price. This is not investment advice.'**
  String get dividendInfoNote;

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentValue(String value);

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @hintDecimal35.
  ///
  /// In en, this message translates to:
  /// **'e.g. 35.00'**
  String get hintDecimal35;

  /// No description provided for @profitLossEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the cost and lot info to run the simulation. Then move the slider to change the price and see your profit/loss instantly.'**
  String get profitLossEmptyMessage;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get salePrice;

  /// No description provided for @costAmount.
  ///
  /// In en, this message translates to:
  /// **'Cost Amount'**
  String get costAmount;

  /// No description provided for @positionValue.
  ///
  /// In en, this message translates to:
  /// **'Position Value'**
  String get positionValue;

  /// No description provided for @profitLossChart.
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss Chart'**
  String get profitLossChart;

  /// No description provided for @breakEven.
  ///
  /// In en, this message translates to:
  /// **'Break-even: {value}'**
  String breakEven(String value);

  /// No description provided for @profitLossInfoNote.
  ///
  /// In en, this message translates to:
  /// **'Profit/loss is calculated only as (sale price − cost) × lots; commissions, taxes and other costs are not included. This is not investment advice.'**
  String get profitLossInfoNote;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailableTitle;

  /// No description provided for @updateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A new version has been released. You can update without reinstalling the app. Your saved calculations and settings are preserved.'**
  String get updateAvailableBody;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @mandatoryUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Mandatory Update'**
  String get mandatoryUpdateTitle;

  /// No description provided for @mandatoryUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. You need to update to keep using the app. Your data is preserved.'**
  String get mandatoryUpdateBody;

  /// No description provided for @updateReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Ready'**
  String get updateReadyTitle;

  /// No description provided for @updateReadyBody.
  ///
  /// In en, this message translates to:
  /// **'The update has been downloaded. Restart the app to complete the installation.'**
  String get updateReadyBody;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading update…'**
  String get updateDownloading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
