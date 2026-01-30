import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/components/widgets/Alert.dart';
import 'package:jkh_mealtoken/components/widgets/app_bar/appbar_title.dart';
import 'package:jkh_mealtoken/components/widgets/app_bar/custom_app_bar.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';
import 'package:jkh_mealtoken/models/meal_summary_results.dart';
import 'package:jkh_mealtoken/models/supplier_mealcard_results.dart';
import 'package:jkh_mealtoken/screens/mealsgrid_screen.dart';
import 'package:jkh_mealtoken/screens/user_login.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../components/widgets/home_item_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key})
      : super(
          key: key,
        );

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
 // DateTime? _lastActiveTime;
  final storage = FlutterSecureStorage();
  late bool visible = false;

  bool alreadyOpen = false;
  FocusNode focusNode = FocusNode();
  TextEditingController barcodeCtrl = TextEditingController();

  //static const sessionTimeout = Duration(hours: 23);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // DateTime currentDate = DateTime.now();

  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  late DateTime selectedDate;

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  void initState() {
    super.initState();
   // _lastActiveTime = DateTime.now();
//startSessionTimer();

    checkSession();
    // allMealprovideddialog();
    // CustomImageView(
    //   imagePath: ImageConstant.imgPowered2,
    //   height: 56.v,
    // );
    selectedDate = today;
  }

  // void startSessionTimer() {
  //   COMMON.timer = Timer(sessionTimeout, () async {
  //     if (DateTime.now().difference(_lastActiveTime!) > sessionTimeout) {
  //       await showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('Session Expired Login Again'),
  //               actions: [
  //                 Center(
  //                   child: ElevatedButton(
  //                     child: Text(
  //                       'OK',
  //                       style: TextStyle(color: Colors.black, fontSize: 20),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context, true);
  //                     },
  //                   ),
  //                 )
  //               ],
  //             );
  //           });
  //       _logout();
  //     } else {
  //       startSessionTimer(); // Restart timer if user interacts
  //     }
  //   });
  // }
  void checkSession() async {
    if (await checkTokenExpired() == true) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Session Expired Login Again',
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    child: Text(
                      'ok',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                )
              ],
            );
          });
      _logout();
    }
  }

  Future<bool> checkTokenExpired() async {
    String? token = await storage.read(key: 'accessToken');
    final jwt = JWT.decode(token ?? '');
    var body = jwt.payload;
    int exp = body['exp'];

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    return DateTime.now().isAfter(dateTime);
  }

  void allMealprovideddialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All Meal Plans Provided'),
          // content: Text(
          //     'All the meal plans have been successfully provided.',style: CustomTextStyles.titleMedium2),),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    // Clear any stored user credentials
    await storage.deleteAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    // DateTime today = DateTime.now();
    // DateTime tomorrow = today.add(Duration(days: 1));

    // Ensure selectedDate is initialized to one of the valid options
    // selectedDate = (selectedDate == today || selectedDate == tomorrow)
    //     ? selectedDate
    //     : today;

    // String formatDate(DateTime date) {
    //   return DateFormat('yyyy/MM/dd').format(date);
    // }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final result = await showDialog(
            context: context,
            builder: (context) => Alert(
              title: 'Are You sure',
              content: Text(
                'Do you Want to exit an App',
                style: TextStyle(
                    color: Colors.black,
                    //fontFamily: 'Centuary Gothic',
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
          key: _scaffoldKey,
          drawer: GridDrawer(),
          appBar: AppBar(
            // backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Text(
              "Today Meal Plan",
              style: TextStyle(fontSize: 22),
            ),
          ),

          //_buildAppBar(context),
          body: VisibilityDetector(
            onVisibilityChanged: (VisibilityInfo info) {
              visible = info.visibleFraction > 0;
            },
            key: Key('visible-detector-key'),
            child: BarcodeKeyboardListener(
              bufferDuration: Duration(milliseconds: 200),
              onBarcodeScanned: (barcode) {
                if (!visible) {
                  return;
                }
                print(barcode);

                //  NavigateToMealGridScreen(barcode: barcode);
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height * 2,
                        decoration: AppDecoration.fillGray,
                        child: Column(
                          children: [
                            SizedBox(height: 15.v),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DropdownButton<DateTime>(
                                        value: selectedDate,
                                        items: [
                                          DropdownMenuItem(
                                            value: today,
                                            child: Text(DateFormat('yyyy/MM/dd')
                                                .format(today)),
                                          ),
                                          DropdownMenuItem(
                                            value: tomorrow,
                                            child: Text(DateFormat('yyyy/MM/dd')
                                                .format(tomorrow)),
                                          ),
                                        ],
                                        onChanged: (DateTime? newValue) {
                                          if (newValue != null) {
                                            updateDate(newValue);
                                          }
                                        },
                                      ),
                                      Container(
                                        width: 200,
                                        child: TextField(
                                          focusNode: focusNode,
                                          controller: barcodeCtrl,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          onEditingComplete: () async {
                                            print(barcodeCtrl.text);

                                            await NavigateToMealGridScreen(
                                                barcode: barcodeCtrl.text);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   currentDate.year.toString() +
                                  //       '/' +
                                  //       currentDate.month
                                  //           .toString()
                                  //           .padLeft(2, '0') +
                                  //       '/' +
                                  //       currentDate.day.toString().padLeft(2, '0'),
                                  //   style: CustomTextStyles.titleMedium4,
                                  // ),
                                  SizedBox(height: 15.v),
                                  // _buildHome(context)
                                  FutureBuilder<MealSummaryResults?>(
                                    future: /*MealController().fetchDayMealSummary(),*/
                                        MealController()
                                            .fetchDayMealSummary(selectedDate),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox.shrink();
                                      } else if (snapshot.hasError) {
                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            // setState(() {
                                            //   MealController()
                                            //       .fetchDayMealSummary();
                                            // });
                                            setState(() {
                                              MealController()
                                                  .fetchDayMealSummary(
                                                      selectedDate);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: Colors.black,
                                          ),
                                          label: Text(
                                            'Refresh',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                      } else {
                                        final mealsummaryResult = snapshot.data;

                                        // Check if all meal plans are provided
                                        bool allMealsProvided = mealsummaryResult
                                                ?.mealsummaryitems
                                                ?.every((item) =>
                                                    (item.mealProvidedCount ??
                                                        0) >=
                                                    (item.mealAllocatedCount ??
                                                        0)) ??
                                            false;

                                        if (allMealsProvided) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            allMealprovideddialog();
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return AlertDialog(
                                            //       title: Text(
                                            //           'All Meal Plans Provided'),
                                            //       // content: Text(
                                            //       //     'All the meal plans have been successfully provided.',style: CustomTextStyles.titleMedium2),),
                                            //       actions: [
                                            //         TextButton(
                                            //           child: Text('OK'),
                                            //           onPressed: () {
                                            //             Navigator.of(context).pop();
                                            //           },
                                            //         ),
                                            //       ],
                                            //     );
                                            //   },
                                            // );
                                          });
                                        }

                                        return ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              height:
                                                  15.0, // Adjust this value as needed
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: mealsummaryResult
                                                  ?.mealsummaryitems?.length ??
                                              0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final summaryItem =
                                                mealsummaryResult!
                                                    .mealsummaryitems![index];

                                            String mealImage = (COMMON.allMeals
                                                            ?.imageItems
                                                            ?.firstWhere(
                                                          (element) =>
                                                              element.mealID ==
                                                              summaryItem
                                                                  .mealId,
                                                          orElse: () =>
                                                              ImageItem(
                                                                  mealImage:
                                                                      ''),
                                                        ) ??
                                                        ImageItem(
                                                            mealImage: ''))
                                                    .mealImage ??
                                                '';
                                            Uint8List imgByte =
                                                base64Decode(mealImage);

                                            return HomeItemWidget(
                                              mealname:
                                                  summaryItem.mealname ?? '',
                                              totcount: summaryItem
                                                      .mealAllocatedCount ??
                                                  0,
                                              servedcount: summaryItem
                                                      .mealProvidedCount ??
                                                  0,
                                              balcount: (summaryItem
                                                          .mealAllocatedCount ??
                                                      0) -
                                                  (summaryItem
                                                          .mealProvidedCount ??
                                                      0),
                                              staffservedcount:
                                                  summaryItem.staffCount ?? 0,
                                              outsidersservedcount:
                                                  summaryItem.temporyCount ?? 0,
                                              mealdes: '',
                                              mealid: '',
                                              byte: imgByte,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomImageView(
                        imagePath: ImageConstant.imgPowered2,
                        height: 56.v,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Draggable(
            child: FloatingActionButton(
              onPressed: () async {
                await _scanBarcode(context);
                // _qrScanned
                //     ? onTapScanStaffID(context, AppRoutes.mealsgrid)
                //     : onTapScanStaffID(context, AppRoutes.homeScreen);
              },
              child: Icon(Icons.document_scanner),
            ),
            feedback: FloatingActionButton(
              onPressed: () {
                // Add your onPressed functionality here
              },
              child: Icon(Icons.adf_scanner),
            ),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              // Add your onDragEnd functionality here
            },
          ),
        ),
      ),
    );
  }

  Future<void> NavigateToMealGridScreen({String? barcode}) async {
    if (barcode!.startsWith("userId")) {
      final String userId = barcode.split(":")[1];
      MealController mealController = MealController();
      MealCardResult? mealCardResult =
          await mealController.fetchMealPlans(userId.trim());

      if (mealCardResult?.success == true && mealCardResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealGridScreen(
              userId: userId,
              mealCardResult: mealCardResult,
            ),
          ),
        );

        //update

        // Show toast message for successful scanning
        _showToast("Scanning Successfully");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No meals allocated"),
              content: Text("Please try again.",
                  style: CustomTextStyles.titleMedium2),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(child: Text("OK")),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error message for invalid format
      _showToast("Invalid Qr Code");

      // Show dialog box for invalid QR code
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid QR Code"),
            content: Text("The scanned QR code is invalid. Please try again.",
                style: CustomTextStyles.titleMedium2),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(child: Text("OK")),
              ),
            ],
          );
        },
      );
    }
  }

  /// Section Widget
  // PreferredSizeWidget _buildAppBar(BuildContext context) {
  //   return CustomAppBar(
  //     leadingWidth: 65.h,
  //     //height: 65.h,
  //     leading: Column(
  //       children: [
  //         // Padding(
  //         //   padding: const EdgeInsets.all(5.0),
  //         //   child: CustomImageView(
  //         //       onTap: () {
  //         //         _scaffoldKey.currentState?.openDrawer();
  //         //       },
  //         //       imagePath: ImageConstant.imgRectangle31,
  //         //       height: 40.v,
  //         //       radius: BorderRadius.circular(
  //         //         10.h,
  //         //       )),
  //         //   // child: IconButton(onPressed: (){
  //         //   //   _scaffoldKey.currentState?.openDrawer();
  //         //   // }, icon: icon)
  //         // ),
  //         IconButton(
  //             onPressed: () {
  //               _scaffoldKey.currentState?.openDrawer();
  //             },
  //             icon: Icon(
  //               Icons.menu,
  //               size: 30,
  //             )),
  //         // Text("SUPPLIERID",
  //         //     style: CustomTextStyles.titleMedium1)
  //       ],
  //     ),
  //     centerTitle: true,
  //     title: AppbarTitle(
  //       text: currentDate.year.toString() +
  //           '/' +
  //           currentDate.month.toString().padLeft(2, '0') +
  //           '/' +
  //           currentDate.day.toString().padLeft(2, '0'),
  //     ),
  //   );
  // }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: message == "Scanning Successfully"
          ? Colors.green
          : Colors.red, // Green for successful, Red for error
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Section Widget
  // Widget _buildHome(BuildContext context) {
  //   return ListView.separated(
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     separatorBuilder: (
  //       context,
  //       index,
  //     ) {
  //       return SizedBox(
  //         height: 25.v,
  //       );
  //     },
  //     itemCount: mealItems.length,
  //     itemBuilder: (context, index) {
  //       return HomeItemWidget(
  //         imagePath: mealItems[index].imagePath,
  //         mealname: mealItems[index].mealname,
  //         totcount: mealItems[index].totcount,
  //         servedcount: mealItems[index].servedcount,
  //         staffservedcount: mealItems[index].staffservedcount,
  //         outsidersservedcount: mealItems[index].outsidersservedcount,
  //       );
  //     },
  //   );
  // }

  Future<void> _scanBarcode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    // Handle the scanned barcode result as you wish
    print(barcodeScanRes);

    if (barcodeScanRes.startsWith("userId")) {
      final String userId = barcodeScanRes.split(":")[1];

      //here needs to validate the user
      MealController mealController = MealController();
      MealCardResult? mealCardResult =
          await mealController.fetchMealPlans(userId.trim());

      if (mealCardResult?.success == true && mealCardResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealGridScreen(
              userId: userId,
              mealCardResult: mealCardResult,
            ),
          ),
        );

        //update

        // Show toast message for successful scanning
        _showToast("Scanning Successfully");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No meals allocated"),
              content: Text("Please try again.",
                  style: CustomTextStyles.titleMedium2),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(child: Text("OK")),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error message for invalid format
      // _showToast("Invalid Qr Code");

      // Show dialog box for invalid QR code
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid QR Code"),
            content: Text("The scanned QR code is invalid. Please try again.",
                style: CustomTextStyles.titleMedium2),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(child: Text("OK")),
              ),
            ],
          );
        },
      );
    }
  }
}

class GridDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64.decode(COMMON.userImageByte);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text(COMMON.NAME, style: CustomTextStyles.titleMedium4),
            accountEmail:
                Text(COMMON.USERID, style: CustomTextStyles.titleMedium4),
            currentAccountPicture: CircleAvatar(
              backgroundImage: bytes.isNotEmpty
                  ? MemoryImage(bytes)
                  : AssetImage('assets/images/image_not_found.png')
                      as ImageProvider, // Replace with your asset path
            ),
          ),
          ListTile(
            title: Text('Home', style: CustomTextStyles.titleMedium5),
            onTap: () {
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
            },
          ),
          ListTile(
            title: Text('Summary', style: CustomTextStyles.titleMedium5),
            onTap: () {
              // Navigate to settings screen
              Navigator.pushNamed(context, AppRoutes.supplierHistoryScreen);
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w600),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Do You Want To Signout?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              await storage.deleteAll();
                              // COMMON.timer?.cancel();
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.loginscreen);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.black),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
