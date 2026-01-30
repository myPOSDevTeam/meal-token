import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jkh_mealtoken/bloc/meal_bloc.dart';
import 'package:jkh_mealtoken/components/widgets/loading_widget.dart';
import 'package:jkh_mealtoken/controllers/api_client.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:jkh_mealtoken/screens/staff_meal_plan_screen.dart';
import 'package:jkh_mealtoken/screens/supplier_meal_screen.dart';
import 'package:jkh_mealtoken/screens/user_login.dart';
import 'package:jkh_mealtoken/screens/supplier_day_summary_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashContent();
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({Key? key}) : super(key: key);

  @override
  State<SplashContent> createState() {
    return _SplashContentState();
  }
}

class _SplashContentState extends State<SplashContent> {
  final storage = FlutterSecureStorage();
  bool isLoggedIn = false;
  // bool _isFirstTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    // double screenWidth = mediaQueryData.size.width;
    // double screenHeight = mediaQueryData.size.height;

    return Scaffold(
      //need to modify the screen

      body: Center(
        child: FutureBuilder(
          future: checkLoginStatus(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingWidget(),
              );
            } else if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }

  Future<Widget> checkLoginStatus() async {
    String? accessToken = await storage.read(key: 'accessToken');
    String? role = await storage.read(key: 'role');

    if (accessToken != null && role?.toUpperCase() == 'STF') {
      // setState(() {
      //   isLoggedIn = true;
      // });
      isLoggedIn = true;
      try {
        COMMON.MOBILE = (await storage.read(key: 'mobile')) ?? '';
        COMMON.NAME = (await storage.read(key: 'name')) ?? '';
        COMMON.USERID = (await storage.read(key: 'userID')) ?? '';
        ApiClient.bearerToken = (await storage.read(key: 'accessToken')) ?? '';
        COMMON.userImageByte = (await storage.read(key: 'userImage')) ?? '';
        COMMON.allMeals = await MealController().fetchMealImage();
      } catch (e) {
        print(e);
      }

      // Navigator.of(context).pushReplacementNamed(AppRoutes.screenone);
      return ScreenoneScreen();
    } else if (accessToken != null && role?.toUpperCase() == 'SUP') {
      // setState(() {
      //   isLoggedIn = true;
      // });
      isLoggedIn = true;
      // Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
      try {
        COMMON.MOBILE = (await storage.read(key: 'mobile')) ?? '';
        COMMON.NAME = (await storage.read(key: 'name')) ?? '';
        COMMON.USERID = (await storage.read(key: 'userID')) ?? '';
        ApiClient.bearerToken = (await storage.read(key: 'accessToken')) ?? '';
        COMMON.userImageByte = (await storage.read(key: 'userImage')) ?? '';
        COMMON.allMeals = await MealController().fetchMealImage();
      } catch (e) {
        print(e);
      }
      await mealBloc.addMealSummaryResult(DateTime.now());
      return SupplierPage();
    } else {
      // Navigator.of(context).pushReplacementNamed(AppRoutes.loginscreen);
      return LoginPage();
    }
  }
}
