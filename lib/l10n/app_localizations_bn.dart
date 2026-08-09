// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ড্রাইভার সঙ্গী';

  @override
  String get welcome => 'স্বাগতম,';

  @override
  String get offDuty => 'ডিউটি অফ';

  @override
  String get onDuty => 'ডিউটিতে আছেন';

  @override
  String get startDuty => 'ডিউটি শুরু করুন';

  @override
  String get endDuty => 'ডিউটি শেষ করুন';

  @override
  String get meterReading => 'মিটার রিডিং (কিমি)';

  @override
  String get currentReading => 'বর্তমান রিডিং';

  @override
  String get logNew => 'নতুন লগ';

  @override
  String get yesterdaysClosing => 'গতকালের ক্লোজিং';

  @override
  String get recentLogs => 'সাম্প্রতিক লগ';

  @override
  String get uploadReceipt => 'রসিদ আপলোড করুন';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get navDashboard => 'ড্যাশবোর্ড';

  @override
  String get navVehicles => 'গাড়িসমূহ';

  @override
  String get navLogs => 'লগস';

  @override
  String get navAccount => 'অ্যাকাউন্ট';

  @override
  String get addExpenseTitle => 'খরচ এন্ট্রি';

  @override
  String get expenseType => 'খরচের ধরন';

  @override
  String get amount => 'টাকার পরিমাণ';

  @override
  String get description => 'বিবরণ (ঐচ্ছিক)';

  @override
  String get uploadReceiptLabel => 'রসিদের ছবি আপলোড করুন';

  @override
  String get saveExpense => 'সেভ করুন';

  @override
  String get typeFuel => 'ফুয়েল';

  @override
  String get typeToll => 'টোল';

  @override
  String get typeParking => 'পার্কিং';

  @override
  String get typeMaintenance => 'মেইনটেন্যান্স';

  @override
  String get typeOther => 'অন্যান্য';

  @override
  String get endDutyTitle => 'ডিউটি শেষের লগ';

  @override
  String get startKm => 'শুরুর কিমি';

  @override
  String get endKm => 'শেষের কিমি';

  @override
  String get totalRun => 'মোট রান কিমি';

  @override
  String get cngRun => 'সিএনজি রান কিমি';

  @override
  String get octaneRun => 'অকটেন রান কিমি';

  @override
  String get nightStay => 'নাইট স্টে (রাত্রিযাপন)';

  @override
  String get extraService => 'এক্সট্রা সার্ভিস (ঘণ্টা)';

  @override
  String get submitLog => 'লগ সাবমিট করুন';

  @override
  String get verifyStartKmTitle => 'মিটার কনফার্ম করুন';

  @override
  String get verifyStartKmDesc =>
      'ডিউটি শুরু করার আগে গাড়ির বর্তমান মিটারের সাথে এই নাম্বারটি মিলিয়ে নিন:';

  @override
  String get cancel => 'বাতিল';

  @override
  String get profileTitle => 'আমার প্রোফাইল';

  @override
  String get personalDetails => 'ব্যক্তিগত তথ্যাদি';

  @override
  String get assignedVehicle => 'নির্ধারিত গাড়ি';

  @override
  String get phoneNumber => 'মোবাইল নম্বর';

  @override
  String get licenseNo => 'লাইসেন্স নম্বর';

  @override
  String get vehicleModel => 'গাড়ির মডেল';

  @override
  String get plateNumber => 'প্লেট নম্বর';

  @override
  String get fuelType => 'জ্বালানির ধরন';

  @override
  String get logout => 'লগআউট';

  @override
  String get tripHistory => 'ট্রিপ হিস্ট্রি';

  @override
  String get navWallet => 'মানিব্যাগ';

  @override
  String get requestAdvance => 'অ্যাডভান্স রিকোয়েস্ট';

  @override
  String get recentAdvances => 'সাম্প্রতিক অ্যাডভান্স';

  @override
  String get totalAdvanceThisMonth => 'মোট অ্যাডভান্স (চলতি মাস)';

  @override
  String get loginTitle => 'স্বাগতম';

  @override
  String get loginSubtitle => 'আপনার অ্যাকাউন্টে লগিন করুন';

  @override
  String get idOrPhoneLabel => 'Employee ID বা Phone Number';

  @override
  String get pinLabel => 'PIN (পিন)';

  @override
  String get loginBtn => 'লগিন করুন';

  @override
  String get errorEmptyInput => 'অনুগ্রহ করে আইডি/ফোন এবং পিন দিন।';

  @override
  String get errorInvalidCredentials => 'ভুল আইডি/ফোন অথবা পিন দিয়েছেন।';

  @override
  String get errorLoginFailed => 'লগইন ব্যর্থ হয়েছে: ';

  @override
  String get errorGeneric => 'একটি ত্রুটি ঘটেছে: ';

  @override
  String get errorInvalidStartKm =>
      'স্টার্ট কি.মি. গত ডিউটির শেষ কি.মি.-এর চেয়ে কম হতে পারবে না';
}
