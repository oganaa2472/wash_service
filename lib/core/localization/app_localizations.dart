import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'l10n/app_en.dart';
import 'l10n/app_mn.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('mn'), // Mongolian
  ];
  
  // Get the appropriate ARB file based on locale
  Map<String, String> get _localizedStrings {
    switch (locale.languageCode) {
      case 'mn':
        return AppMn.messages;
      case 'en':
      default:
        return AppEn.messages;
    }
  }
  
  // Helper method to get translated string
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
  
  // Common translations
  String get appName => translate('appName');
  String get appTagline => translate('appTagline');
  String get login => translate('login');
  String get email => translate('email');
  String get phone => translate('phone');
  String get password => translate('password');
  String get confirmPassword => translate('confirmPassword');
  String get submit => translate('submit');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get add => translate('add');
  String get search => translate('search');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get info => translate('info');
  String get retry => translate('retry');
  String get back => translate('back');
  String get next => translate('next');
  String get previous => translate('previous');
  String get done => translate('done');
  String get skip => translate('skip');
  String get continue_ => translate('continue');
  String get finish => translate('finish');
  String get close => translate('close');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  
  // Auth related translations
  String get loginTitle => translate('loginTitle');
  String get loginSubtitle => translate('loginSubtitle');
  String get enterEmailOrPhone => translate('enterEmailOrPhone');
  String get enterValidEmail => translate('enterValidEmail');
  String get enterValidPhone => translate('enterValidPhone');
  String get sendOtp => translate('sendOtp');
  String get verifyOtp => translate('verifyOtp');
  String get otpSent => translate('otpSent');
  String get enterOtp => translate('enterOtp');
  String get resendOtp => translate('resendOtp');
  String get resendOtpIn => translate('resendOtpIn');
  String get invalidOtp => translate('invalidOtp');
  String get otpExpired => translate('otpExpired');
  String get loginSuccess => translate('loginSuccess');
  String get loginFailed => translate('loginFailed');
  String get logout => translate('logout');
  String get logoutSuccess => translate('logoutSuccess');
  String get logoutFailed => translate('logoutFailed');
  
  // Home page translations
  String get home => translate('home');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get notifications => translate('notifications');
  String get help => translate('help');
  String get about => translate('about');
  String get contactUs => translate('contactUs');
  String get privacyPolicy => translate('privacyPolicy');
  String get termsOfService => translate('termsOfService');
  
  // Company related translations
  String get companies => translate('companies');
  String get company => translate('company');
  String get addCompany => translate('addCompany');
  String get editCompany => translate('editCompany');
  String get companyName => translate('companyName');
  String get companyAddress => translate('companyAddress');
  String get companyLogo => translate('companyLogo');
  String get companyCategory => translate('companyCategory');
  String get companyDetails => translate('companyDetails');
  String get companyAdded => translate('companyAdded');
  String get companyUpdated => translate('companyUpdated');
  String get companyDeleted => translate('companyDeleted');
  
  // Order related translations
  String get orders => translate('orders');
  String get order => translate('order');
  String get addOrder => translate('addOrder');
  String get editOrder => translate('editOrder');
  String get orderDetails => translate('orderDetails');
  String get orderStatus => translate('orderStatus');
  String get orderDate => translate('orderDate');
  String get orderTime => translate('orderTime');
  String get orderTotal => translate('orderTotal');
  String get orderPayment => translate('orderPayment');
  String get orderCompleted => translate('orderCompleted');
  String get orderCancelled => translate('orderCancelled');
  String get orderPending => translate('orderPending');
  
  // Service related translations
  String get services => translate('services');
  String get service => translate('service');
  String get serviceName => translate('serviceName');
  String get serviceDescription => translate('serviceDescription');
  String get servicePrice => translate('servicePrice');
  String get serviceDuration => translate('serviceDuration');
  String get serviceCategory => translate('serviceCategory');
  
  // Payment related translations
  String get payment => translate('payment');
  String get paymentMethod => translate('paymentMethod');
  String get paymentMethods => translate('paymentMethods');
  String get addPaymentMethod => translate('addPaymentMethod');
  String get editPaymentMethod => translate('editPaymentMethod');
  String get paymentDetails => translate('paymentDetails');
  String get paymentSuccess => translate('paymentSuccess');
  String get paymentFailed => translate('paymentFailed');
  String get paymentPending => translate('paymentPending');
  String get paymentCancelled => translate('paymentCancelled');
  
  // Error messages
  String get networkError => translate('networkError');
  String get serverError => translate('serverError');
  String get unknownError => translate('unknownError');
  String get tryAgain => translate('tryAgain');
  String get checkConnection => translate('checkConnection');
  
  // Validation messages
  String get requiredField => translate('requiredField');
  String get invalidFormat => translate('invalidFormat');
  String get minLength => translate('minLength');
  String get maxLength => translate('maxLength');
  String get invalidEmail => translate('invalidEmail');
  String get invalidPhone => translate('invalidPhone');
  String get passwordMismatch => translate('passwordMismatch');
  
  // Verification related translations
  String get verificationCode => translate('verificationCode');
  String get weHaveSentCode => translate('weHaveSentCode');
  String get didntReceiveCode => translate('didntReceiveCode');
  String get verify => translate('verify');
  String get pleaseEnter6DigitCode => translate('pleaseEnter6DigitCode');
  String get pleaseEnterOnlyNumbers => translate('pleaseEnterOnlyNumbers');
  
  // Assistant related translations
  String get assistant => translate('assistant');
  String get assistantTitle => translate('assistantTitle');
  String get assistantSubtitle => translate('assistantSubtitle');
  String get askQuestion => translate('askQuestion');
  String get send => translate('send');
  String get typing => translate('typing');
  
  // Wash Service related translations
  String get washService => translate('washService');
  String get washServices => translate('washServices');
  String get addWashService => translate('addWashService');
  String get editWashService => translate('editWashService');
  String get washServiceDetails => translate('washServiceDetails');
  String get washServiceName => translate('washServiceName');
  String get washServicePrice => translate('washServicePrice');
  String get washServiceDuration => translate('washServiceDuration');
  String get washServiceDescription => translate('washServiceDescription');
  
  // Employee related translations
  String get employees => translate('employees');
  String get employee => translate('employee');
  String get addEmployee => translate('addEmployee');
  String get editEmployee => translate('editEmployee');
  String get employeeDetails => translate('employeeDetails');
  String get employeeName => translate('employeeName');
  String get employeePhone => translate('employeePhone');
  String get employeeEmail => translate('employeeEmail');
  String get employeeRole => translate('employeeRole');
  
  // Car related translations
  String get cars => translate('cars');
  String get car => translate('car');
  String get addCar => translate('addCar');
  String get editCar => translate('editCar');
  String get carDetails => translate('carDetails');
  String get carBrand => translate('carBrand');
  String get carModel => translate('carModel');
  String get carYear => translate('carYear');
  String get carColor => translate('carColor');
  String get carPlate => translate('carPlate');
  
  // Version related translations
  String get versionCheck => translate('versionCheck');
  String get updateAvailable => translate('updateAvailable');
  String get currentVersion => translate('currentVersion');
  String get latestVersion => translate('latestVersion');
  String get updateNow => translate('updateNow');
  String get skipUpdate => translate('skipUpdate');
  String get youAreUsingLatestVersion => translate('youAreUsingLatestVersion');
  String get failedToCheckUpdates => translate('failedToCheckUpdates');
  
  // General error messages
  String get generalError => translate('generalError');
  String get networkErrorShort => translate('networkErrorShort');
  
  // Date and time formatting
  String formatDate(DateTime date) {
    return DateFormat.yMMMd(locale.languageCode).format(date);
  }
  
  String formatTime(DateTime time) {
    return DateFormat.Hm(locale.languageCode).format(time);
  }
  
  String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd(locale.languageCode).add_jm().format(dateTime);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'mn'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 