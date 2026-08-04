import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('bn'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Driver Companion'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'WELCOME,'**
  String get welcome;

  /// No description provided for @offDuty.
  ///
  /// In en, this message translates to:
  /// **'OFF DUTY'**
  String get offDuty;

  /// No description provided for @onDuty.
  ///
  /// In en, this message translates to:
  /// **'ON DUTY'**
  String get onDuty;

  /// No description provided for @startDuty.
  ///
  /// In en, this message translates to:
  /// **'START DUTY'**
  String get startDuty;

  /// No description provided for @endDuty.
  ///
  /// In en, this message translates to:
  /// **'END DUTY'**
  String get endDuty;

  /// No description provided for @meterReading.
  ///
  /// In en, this message translates to:
  /// **'METER READING (KM)'**
  String get meterReading;

  /// No description provided for @currentReading.
  ///
  /// In en, this message translates to:
  /// **'Current Reading'**
  String get currentReading;

  /// No description provided for @logNew.
  ///
  /// In en, this message translates to:
  /// **'LOG NEW'**
  String get logNew;

  /// No description provided for @yesterdaysClosing.
  ///
  /// In en, this message translates to:
  /// **'Yesterday\'s Closing'**
  String get yesterdaysClosing;

  /// No description provided for @recentLogs.
  ///
  /// In en, this message translates to:
  /// **'RECENT LOGS'**
  String get recentLogs;

  /// No description provided for @uploadReceipt.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD RECEIPT'**
  String get uploadReceipt;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL'**
  String get optional;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navVehicles;

  /// No description provided for @navLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navLogs;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'ADD EXPENSE'**
  String get addExpenseTitle;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense Type'**
  String get expenseType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount (BDT)'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get description;

  /// No description provided for @uploadReceiptLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload Receipt Image'**
  String get uploadReceiptLabel;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'SAVE EXPENSE'**
  String get saveExpense;

  /// No description provided for @typeFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get typeFuel;

  /// No description provided for @typeToll.
  ///
  /// In en, this message translates to:
  /// **'Toll'**
  String get typeToll;

  /// No description provided for @typeParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get typeParking;

  /// No description provided for @typeMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get typeMaintenance;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get typeOther;

  /// No description provided for @endDutyTitle.
  ///
  /// In en, this message translates to:
  /// **'END DUTY LOG'**
  String get endDutyTitle;

  /// No description provided for @startKm.
  ///
  /// In en, this message translates to:
  /// **'Start KM'**
  String get startKm;

  /// No description provided for @endKm.
  ///
  /// In en, this message translates to:
  /// **'End KM'**
  String get endKm;

  /// No description provided for @totalRun.
  ///
  /// In en, this message translates to:
  /// **'Total Run KM'**
  String get totalRun;

  /// No description provided for @cngRun.
  ///
  /// In en, this message translates to:
  /// **'CNG Run KM'**
  String get cngRun;

  /// No description provided for @octaneRun.
  ///
  /// In en, this message translates to:
  /// **'Octane Run KM'**
  String get octaneRun;

  /// No description provided for @nightStay.
  ///
  /// In en, this message translates to:
  /// **'Night Stay'**
  String get nightStay;

  /// No description provided for @extraService.
  ///
  /// In en, this message translates to:
  /// **'Extra Service (Hours)'**
  String get extraService;

  /// No description provided for @submitLog.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT LOG'**
  String get submitLog;

  /// No description provided for @verifyStartKmTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Start KM'**
  String get verifyStartKmTitle;

  /// No description provided for @verifyStartKmDesc.
  ///
  /// In en, this message translates to:
  /// **'Please verify the current meter reading before starting duty:'**
  String get verifyStartKmDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'MY PROFILE'**
  String get profileTitle;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL DETAILS'**
  String get personalDetails;

  /// No description provided for @assignedVehicle.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNED VEHICLE'**
  String get assignedVehicle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @licenseNo.
  ///
  /// In en, this message translates to:
  /// **'License No'**
  String get licenseNo;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logout;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'TRIP HISTORY'**
  String get tripHistory;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @requestAdvance.
  ///
  /// In en, this message translates to:
  /// **'REQUEST ADVANCE'**
  String get requestAdvance;

  /// No description provided for @recentAdvances.
  ///
  /// In en, this message translates to:
  /// **'Recent Advances'**
  String get recentAdvances;

  /// No description provided for @totalAdvanceThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Total Advance (This Month)'**
  String get totalAdvanceThisMonth;
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
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
