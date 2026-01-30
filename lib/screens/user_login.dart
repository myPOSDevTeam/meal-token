import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_imei/device_imei.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jkh_mealtoken/bloc/meal_bloc.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/components/widgets/Alert.dart';
import 'package:jkh_mealtoken/components/widgets/custom_elevated_button.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';
import 'package:jkh_mealtoken/controllers/api_client.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final dio = Dio();
  bool _calculating = false;

  //bool _qrScanned = false;
  bool status = false;
  bool isLoggedIn = false;



  void _doCalc(String mobileNo) async {
    _setCalculating(true);
    await requestOTP(mobileNo);

    _setCalculating(false);
  }

  void _setCalculating(bool calculating) {
    if (mounted) {
      setState(() {
        _calculating = calculating;
        print("Setting state: $calculating");
      });
    }
  }
    final player = AudioPlayer();

    void playAcceptedSound() async {
    await player.play(AssetSource('sounds/success.mp3'));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final result = await showDialog(
            context: context,
            builder: (context) => Alert(
              title: 'Are You sure',
              content: Text(
                'Do you want to exit an App',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              ),
              actions: [
                ElevatedButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.038,
                          //fontFamily: "Century Gothic",
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    } //Navigator.pop( context, false)
                    ),
                ElevatedButton(
                    onPressed: () {
                      // SystemNavigator.pop();
                      // Navigator.pop(context, true);
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.038,
                          //fontFamily: "Century Gothic",
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
          if (result) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 160, 206, 243).withOpacity(0.1),
        backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Enter the base url'),
                        actions: [
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            controller: _urlController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.webhook),
                                labelText: "Enter the Url"),
                          ),
                          TextButton(
                              onPressed: () {
                                ApiClient.baseURL = _urlController.text
                                        .trim()
                                        .isNotEmpty
                                    ? _urlController.text.trim()
                                    : 'https://lpimtapi.keellssuper.net/api/';
                                EasyLoading.showSuccess("Url Saved");
                                Navigator.pop(context);
                                _urlController.clear();
                              },
                              child: Text('Submit'))
                        ],
                      );
                    });
              },
              child: Icon(
                Icons.settings,
              )),
          backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
          automaticallyImplyLeading: false,
          title: Text(
            'Login',
            style: CustomTextStyles.titleMedium,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 20,),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: 'Enter Mobile No',
                        border: OutlineInputBorder(
                          // Customize the border
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust border radius as needed
                          // borderSide:BorderSide(), // You can customize the border color, width, etc.
                        ),
                        // You can add additional decoration properties here
                      ),
                    ),
                    SizedBox(height: 69.v),
                    CustomElevatedButton(
                      height: 66.v,
                      text: !_calculating ? "Login" : "Loading...",
                      onPressed: () {
                        // playAcceptedSound();
                        print(ApiClient.baseURL);
                        if (_mobileController.text.trim().length == 9 ||
                            _mobileController.text.trim().length == 10 ||
                            _mobileController.text.trim().length == 11) {
                          _doCalc(_mobileController.text);
                          //  requestOTP(_mobileController.text);
                        } else {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.black,
                            msg: "Not assign a valid Number",
                            backgroundColor: Colors.red,
                            // webBgColor: Colors.red
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 30),

              SizedBox(height: 35.h),
              CustomImageView(
                imagePath: ImageConstant.imgPowered2,
                height: 56.v,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the scanScreenoneScreen when the action is triggered.
  onTapScanStaffID(BuildContext context) async {
    await mealBloc.addMealSummaryResult(DateTime.now());
    Navigator.pushReplacementNamed(context, AppRoutes.supplerScreen);
    // Navigator.pushReplacementNamed(context, AppRoutes.barcodeReader);
  }

  onTapScreenOne(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.screenone);
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 4, 227, 12),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> requestOTP(String mobile) async {
    try {
      var body = json.encode({"mobileNo": mobile.trim()});
      var response = await ApiClient.call('Login/mobile', ApiMethod.POST,
          data: json.decode(body), authorized: false);

      if (response?.statusCode == 200) {
        Map<String, dynamic> responseData = (response?.data);
        String otp = responseData['data']['otp'];
        String accessToken = responseData['accessToken'];

        ApiClient.bearerToken = accessToken;
        // COMMON.MOBILE = responseData['data']['name'];
        COMMON.ROLE = responseData['data']['role'];
        COMMON.MOBILE = responseData['data']['mobile'];
        COMMON.NAME = responseData['data']['name'];
        COMMON.USERID = responseData['data']['userID'];
        COMMON.userImageByte = responseData['data']['userImage'] ?? '';
        //last update

        //

        final res = await _showOTPDialog(otp, accessToken);
        if (res == true) {
          COMMON.allMeals = await MealController().fetchMealImage();
          // if (COMMON.ROLE == 'STF') {
          //   onTapScreenOne(context);
          // } else

          if (COMMON.ROLE == 'SUP') {
            onTapScanStaffID(context);
          }
        }
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e);
      // Handle errors here
    }
  }

  Future<void> handleLoginSuccess(String accessToken) async {
    await storage.write(key: 'mobile', value: COMMON.MOBILE);
    await storage.write(key: 'name', value: COMMON.NAME);
    await storage.write(key: 'role', value: COMMON.ROLE);
    await storage.write(key: 'userID', value: COMMON.USERID);
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'userImage', value: COMMON.userImageByte);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<bool> _showOTPDialog(String otp, String accessToken) async {
    bool? res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter OTP'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  // Text('OTP: $otp'),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'OTP'),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit'),
                onPressed: () async {
                  String enteredOTP = _otpController.text;
                  if (enteredOTP == otp) {
                    await handleLoginSuccess(accessToken);
                    Navigator.pop(context, true);
                  } else {
                    Fluttertoast.showToast(
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Colors.black,
                      msg: "Entered OTP is Wrong",
                      backgroundColor: Colors.red,
                      // webBgColor: Colors.red
                    );
                  }
                },
              )
            ],
          );
        });
    return res == true;
    // return (futureBool as bool);
  }

  Future<bool> saveSharedPreferences(String mobile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString('mobile', mobile);
  }

  Future<bool> _onWillPop() async {
    final futureBool = await showDialog(
        context: context,
        builder: (context) => Alert(
              title: 'Exit',
              content: Text(
                'Do you want to exit an App',
                style: TextStyle(
                    color: Colors.black,
                    // fontFamily: "Centuary Gothic",
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                        // fontFamily: "Centuary Gothic",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () => SystemNavigator.pop(),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.038,
                        // fontFamily: "Centuary Gothic",
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ));
    return futureBool;
  }
}
