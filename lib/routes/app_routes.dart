import 'package:device_imei/device_imei.dart';
import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/screens/barcode_reader.dart';
import 'package:jkh_mealtoken/screens/deviceInfo.dart';
import 'package:jkh_mealtoken/screens/staff_history.dart';
import 'package:jkh_mealtoken/screens/supplier_day_summary_screen.dart';
import 'package:jkh_mealtoken/screens/profile.dart';
import 'package:jkh_mealtoken/screens/staff_meal_plan_screen.dart';
import 'package:jkh_mealtoken/screens/splash_screen/splash_screen.dart';
import 'package:jkh_mealtoken/screens/token_expired.dart';
import 'package:jkh_mealtoken/screens/supplier_meal_screen.dart';
import 'package:jkh_mealtoken/screens/user_login.dart';
import 'package:jkh_mealtoken/screens/supplier_history.dart';

class AppRoutes {
  late final String userId;

  static const String detailPageoneScreen = '/detail_pageone_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  // static const String onboardingScreen = '/onboarding_screen';

  static const String loginscreen = '/login_screen';

  static const String screenone = '/screenone_screen';

  static const String mealsgrid = '/mealsgrid_screen';

  static const String homeScreen = '/home_screen';

  static const String supplerScreen = '/suppler_screen';

  static const String spalashScreen = '/splash_screen';

  static const String profileScreen = '/profile';

  static const String historyScreen = '/history';

  static const String supplierHistoryScreen = '/supplier_history';

  static const String staffHistoryScreen = '/staff_history';

  static const String barcodeReader = '/barcode_reader';

  static const String tokenExpired = '/token_expired';

  static const String deviceInfo = '/deviceInfo';

  static Map<String, WidgetBuilder> routes = {
    // appNavigationScreen: (context) => AppNavigationScreen(),
    // onboardingScreen: (context) => OnboardingScreen(),
    homeScreen: (context) => HomePage(),
    loginscreen: (context) => LoginPage(),
    screenone: (context) => ScreenoneScreen(),
    deviceInfo:(context)=> DeviceinfoScreen(),
    // mealsgrid: (context) => MealGridScreen(
    //       userId: '',
    //       mealCardResult: '',
    //     ),
    spalashScreen: (context) => SplashScreen(),
    profileScreen: (context) => Profile(),
    historyScreen: (context) => StaffMealHistory(),
    supplierHistoryScreen: (context) => SupplierHistory(),
    staffHistoryScreen: (context) => StaffMealHistory(),
    barcodeReader: (context) => BarcodeScanner(),
    tokenExpired: (context) => TokenExpired(),
    supplerScreen: (context) => SupplierPage(),
  };
}
