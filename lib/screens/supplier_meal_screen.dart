import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jkh_mealtoken/bloc/meal_bloc.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/components/widgets/Alert.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';
import 'package:jkh_mealtoken/components/widgets/home_widget_supplier.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';
import 'package:jkh_mealtoken/models/meal_summary_results.dart';
import 'package:jkh_mealtoken/models/supplier_mealcard_results.dart';
import 'package:jkh_mealtoken/screens/mealsgrid_screen.dart';
import 'package:jkh_mealtoken/screens/user_login.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class SupplierPage extends StatefulWidget {
  const SupplierPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  SupplierPageState createState() => SupplierPageState();
}

class SupplierPageState extends State<SupplierPage> {
  // DateTime? _lastActiveTime;
  final storage = FlutterSecureStorage();
  late bool visible = false;
  List<MealSummaryItem?> _selectedMealsList = [];

  bool alreadyOpen = false;
  FocusNode focusNode = FocusNode();
  TextEditingController barcodeCtrl = TextEditingController();
  // FocusNode pageFocus = FocusNode();
  // static const sessionTimeout = Duration(hours: 23);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // DateTime currentDate = DateTime.now();

  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  late DateTime selectedDate;
  Timer? _logoutTimer;
  static const Duration _timeoutDuration = Duration(minutes: 30);
  static const String _lastActiveKey = 'lastActive';

  final player = AudioPlayer();
  String? _lastScannedBarcode;
  bool _isDialogOpen = false;

  void playAcceptedSound() async {
    await player.play(AssetSource('sounds/success.mp3'));
  }

  void playRejectSound() async {
    await player.play(AssetSource('sounds/beep.mp3'));
  }

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _selectedMealsList = [];
    });
    _resetLogoutTimer();
  }

  @override
  void initState() {
    super.initState();
    checkSession();
    selectedDate = today;
    //newly added
    _initializeSession();
    //-------
    _resetLogoutTimer();
    // focusNode.requestFocus();
  }

  @override
  void dispose() {
    barcodeCtrl.dispose();
    focusNode.dispose();
    _logoutTimer?.cancel();

    super.dispose();
  }

  _resetLogoutTimer() async {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(_timeoutDuration, _logout);
    //---------------
    await _updateLastActiveTimestamp();
    //-------------------------------
  }

  void checkSession() async {
    if (await checkTokenExpired() == true) {
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

  Future<void> _initializeSession() async {
    await _checkInactivity();
    _resetLogoutTimer();
  }

//------------newly added
  // Updates the last activity timestamp in secure storage
  Future<void> _updateLastActiveTimestamp() async {
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch.toString();
    await storage.write(key: _lastActiveKey, value: currentTimeMillis);
  }

  // Checks if 30 minutes have passed since the last activity and logs out if necessary
  Future<void> _checkInactivity() async {
    final lastActiveMillisStr = await storage.read(key: _lastActiveKey);

    if (lastActiveMillisStr != null) {
      final lastActiveMillis = int.parse(lastActiveMillisStr);
      final lastActiveTime =
          DateTime.fromMillisecondsSinceEpoch(lastActiveMillis);
      final inactivityDuration = DateTime.now().difference(lastActiveTime);

      if (inactivityDuration > _timeoutDuration) {
        _logout();
      }
    }
  }
  //----------------

  // void allMealprovideddialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('All Meal Plans Provided'),
  //         // content: Text(
  //         //     'All the meal plans have been successfully provided.',style: CustomTextStyles.titleMedium2),),
  //         actions: [
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _logout() async {
    // Clear any stored user credentials
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
    await storage.deleteAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _resetLogoutTimer(),
      child: PopScope(
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
                caseSensitive: true,
                // bufferDuration: Duration(milliseconds: 400),
                onBarcodeScanned: (barcode) async {
                  if (!visible) {
                    return;
                  }
                  //   if (_selectedMealsList.isNotEmpty) {
                  //                 print(barcodeCtrl.text);
                  //                 await updateStaffMealPlan(barcode);
                  //                 await mealBloc
                  //                     .addMealSummaryResult(selectedDate);
                  //                 // setState(() {});
                  //               } else {
                  //                 showDialog(
                  //                   context: context,
                  //                   builder: (BuildContext context) {
                  //                     return AlertDialog(
                  //                       content: Text(
                  //                         'Please select at least one meal plan.',
                  //                         style: CustomTextStyles.titleMedium2,
                  //                       ),
                  //                       actions: [
                  //                         ElevatedButton(
                  //                           onPressed: () {
                  //                             barcodeCtrl.clear();
                  //                             Navigator.of(context).pop();
                  //                           },
                  //                           child: Text('Yes',
                  //                               style: TextStyle(
                  //                                   color: Colors.white)),
                  //                         )
                  //                       ],
                  //                     );
                  //                   },
                  //                 );
                  //               }

                  //  NavigateToMealGridScreen(barcode: barcode);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<DateTime>(
                            value: selectedDate,
                            items: [
                              DropdownMenuItem(
                                value: today,
                                child: Text(
                                    DateFormat('yyyy/MM/dd').format(today)),
                              ),
                              DropdownMenuItem(
                                value: tomorrow,
                                child: Text(
                                    DateFormat('yyyy/MM/dd').format(tomorrow)),
                              ),
                            ],
                            onChanged: (DateTime? newValue) async {
                              if (newValue != null) {
                                await mealBloc.addMealSummaryResult(newValue);
                                updateDate(newValue);
                              }
                            },
                          ),
                          Container(
                              width: 200,
                              // child: TextField(
                              //   // readOnly: true,
                              //   // keyboardType: null,
                              //   // keyboardAppearance: false,
                              //   focusNode: focusNode,
                              //   controller: barcodeCtrl,
                              //   autofocus: true,
                              //   decoration: InputDecoration(
                              //     contentPadding: EdgeInsets.all(5),
                              //     border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8)),
                              //   ),
                              //   // onSubmitted: (v) async{
                              //   //    if (_selectedMealsList.isNotEmpty) {
                              //   //     print(barcodeCtrl.text);
                              //   //     await updateStaffMealPlan(barcodeCtrl.text);
                              //   //     await mealBloc
                              //   //         .addMealSummaryResult(selectedDate);
                              //   //     // setState(() {});
                              //   //   } else {
                              //   //     showDialog(
                              //   //       context: context,
                              //   //       builder: (BuildContext context) {
                              //   //         return AlertDialog(
                              //   //           content: Text(
                              //   //             'Please select at least one meal plan.',
                              //   //             style: CustomTextStyles.titleMedium2,
                              //   //           ),
                              //   //           actions: [
                              //   //             ElevatedButton(
                              //   //               onPressed: () {
                              //   //                 barcodeCtrl.clear();
                              //   //                 Navigator.of(context).pop();
                              //   //               },
                              //   //               child: Text('Yes',
                              //   //                   style: TextStyle(
                              //   //                       color: Colors.white)),
                              //   //             )
                              //   //           ],
                              //   //         );
                              //   //       },
                              //   //     );
                              //   //   }

                              //   // },
                              //   onEditingComplete: () async {
                              //     if (_selectedMealsList.isNotEmpty) {
                              //       print(barcodeCtrl.text);
                              //       await updateStaffMealPlan(barcodeCtrl.text);
                              //       await mealBloc
                              //           .addMealSummaryResult(selectedDate);
                              //       // setState(() {});
                              //     } else {
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) {
                              //           return AlertDialog(
                              //             content: Text(
                              //               'Please select at least one meal plan.',
                              //               style: CustomTextStyles.titleMedium2,
                              //             ),
                              //             actions: [
                              //               ElevatedButton(
                              //                 onPressed: () {
                              //                   barcodeCtrl.clear();
                              //                   Navigator.of(context).pop();
                              //                 },
                              //                 child: Text('Yes',
                              //                     style: TextStyle(
                              //                         color: Colors.white)),
                              //               )
                              //             ],
                              //           );
                              //         },
                              //       );
                              //     }

                              //     // await NavigateToMealGridScreen(
                              //     //     barcode: barcodeCtrl.text);
                              //   },
                              // ),

                              child: TextField(
                                focusNode: focusNode,
                                controller: barcodeCtrl,
                                autofocus: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onEditingComplete: () async {
                                  /// 🔴 VALIDATION: No meal selected
                                  if (_selectedMealsList.isEmpty) {
                                    playRejectSound();
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Invalid Selection",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(
                                          "Please select a meal before entering the barcode.",
                                          style: CustomTextStyles.titleMedium2,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              barcodeCtrl.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  /// 🔴 VALIDATION: Multiple meals selected
                                  if (_selectedMealsList.length > 1) {
                                    playRejectSound();
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Invalid Selection",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(
                                          "Multiple meals selected.\nPlease select only ONE meal to continue.",
                                          style: CustomTextStyles.titleMedium2,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              barcodeCtrl.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  /// 🔴 VALIDATION: Empty barcode
                                  if (barcodeCtrl.text.trim().isEmpty) {
                                    playRejectSound();
                                    EasyLoading.showError(
                                        "Please enter or scan a valid barcode.");
                                    return;
                                  }

                                  /// ✅ VALID CASE
                                  print(barcodeCtrl.text);
                                  await updateStaffMealPlan(barcodeCtrl.text);
                                  await mealBloc
                                      .addMealSummaryResult(selectedDate);

                                  barcodeCtrl.clear();
                                  focusNode
                                      .requestFocus(); // keep focus for next scan
                                },
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                // height: MediaQuery.of(context).size.height * 2,
                                // decoration: AppDecoration.fillGray,
                                child: Column(
                                  children: [
                                    SizedBox(height: 15.v),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15.v),
                                          // _buildHome(context)
                                          StreamBuilder<MealSummaryResults?>(
                                            stream:
                                                mealBloc.mealSummarySnapshot,
                                            /*MealController().fetchDayMealSummary(),*/

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
                                                    // setState(() {
                                                    //   MealController()
                                                    //       .fetchDayMealSummary(
                                                    //           selectedDate);
                                                    // });
                                                  },
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    color: Colors.black,
                                                  ),
                                                  label: Text(
                                                    'Refresh',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                );
                                              } else {
                                                final mealsummaryResult =
                                                    snapshot.data;
                                                List list = [];
                                                list.addAll(_selectedMealsList);
                                                for (int i = 0;
                                                    i < list.length;
                                                    i++) {
                                                  if (mealsummaryResult
                                                          ?.mealsummaryitems
                                                          ?.indexWhere((e) =>
                                                              e.mealId ==
                                                                  list[i]
                                                                      ?.mealId &&
                                                              ((e.mealProvidedCount ??
                                                                      0) >=
                                                                  (e.mealAllocatedCount ??
                                                                      0))) !=
                                                      -1) {
                                                    EasyLoading.showInfo(
                                                        '${list[i]?.mealDes} is over');
                                                    _selectedMealsList
                                                        .removeAt(i);
                                                  }
                                                }
                                                // Check if all meal plans are provided
                                                // bool allMealsProvided = mealsummaryResult
                                                //         ?.mealsummaryitems
                                                //         ?.every((item) =>
                                                //             (item.mealProvidedCount ??
                                                //                 0) >=
                                                //             (item.mealAllocatedCount ??

                                                //                 0)) ??
                                                //     false;

                                                // if (allMealsProvided) {
                                                //   WidgetsBinding.instance
                                                //       .addPostFrameCallback((_) {
                                                //    // allMealprovideddialog();
                                                //     showDialog(
                                                //       context: context,
                                                //       builder: (BuildContext context) {
                                                //         return AlertDialog(
                                                //           title: Text(
                                                //               'All Meal Plans Provided'),
                                                //           // content: Text(
                                                //           //     'All the meal plans have been successfully provided.',style: CustomTextStyles.titleMedium2),),
                                                //           actions: [
                                                //             TextButton(
                                                //               child: Text('OK'),
                                                //               onPressed: () {
                                                //                 Navigator.of(context)
                                                //                     .pop();
                                                //               },
                                                //             ),
                                                //           ],
                                                //         );
                                                //       },
                                                //     );
                                                //   });
                                                // }

                                                return ListView.separated(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      height:
                                                          15.0, // Adjust this value as needed
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  itemCount: mealsummaryResult
                                                          ?.mealsummaryitems
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final summaryItem =
                                                        mealsummaryResult!
                                                                .mealsummaryitems![
                                                            index];

                                                    String mealImage = (COMMON
                                                                    .allMeals
                                                                    ?.imageItems
                                                                    ?.firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .mealID ==
                                                                      summaryItem
                                                                          .mealId,
                                                                  orElse: () =>
                                                                      ImageItem(
                                                                          mealImage:
                                                                              ''),
                                                                ) ??
                                                                ImageItem(
                                                                    mealImage:
                                                                        ''))
                                                            .mealImage ??
                                                        '';
                                                    Uint8List imgByte =
                                                        base64Decode(mealImage);

                                                    var a = _selectedMealsList
                                                        .indexWhere(
                                                            (element) =>
                                                                element
                                                                    ?.mealId ==
                                                                summaryItem
                                                                    .mealId,
                                                            -1);

                                                    return HomeItemSupplierWidget(
                                                      mealname: summaryItem
                                                              .mealname ??
                                                          '',
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
                                                          summaryItem
                                                                  .staffCount ??
                                                              0,
                                                      outsidersservedcount:
                                                          summaryItem
                                                                  .temporyCount ??
                                                              0,
                                                      mealdes: '',
                                                      mealid: '',
                                                      byte: imgByte,
                                                      isSelected: a != -1,
                                                      onTap: () {
                                                        _resetLogoutTimer();
                                                        setState(() {
                                                          focusNode
                                                              .requestFocus();

                                                          if (a != -1) {
                                                            _selectedMealsList
                                                                .removeAt(a);
                                                          } else {
                                                            focusNode
                                                                .requestFocus();

                                                            _selectedMealsList
                                                                .add(
                                                                    summaryItem);
                                                          }
                                                        });
                                                      },
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgPowered2,
                      height: 56.v,
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: Draggable(
              child: FloatingActionButton(
                onPressed: () async {
                  if (_selectedMealsList.isNotEmpty) {
                    await _scanBarcode(context);
                    await mealBloc.addMealSummaryResult(selectedDate);
                    // setState(() {});
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            'Please select at least one meal plan.',
                            style: CustomTextStyles.titleMedium2,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Yes',
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        );
                      },
                    );
                  }
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
              onDragEnd: (details) {},
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: message.toLowerCase().contains("successfully")
          ? Colors.green
          : Colors.red, // Green for successful, Red for error
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    /// 🔴 VALIDATION: No meal selected
    if (_selectedMealsList.isEmpty) {
      playRejectSound();
      EasyLoading.showError(
        'Please select a meal before scanning.',
      );
      return;
    }

    /// 🔴 VALIDATION: Multiple meals selected
    if (_selectedMealsList.length > 1) {
      playRejectSound();
      EasyLoading.showError(
        'Multiple meals selected.\nPlease select only ONE meal to scan.',
      );
      return;
    }
    var res = await MealController().fetchDayMealSummary(selectedDate);

    List list = [];
    list.addAll(_selectedMealsList);
    for (int i = 0; i < list.length; i++) {
      if (res?.mealsummaryitems?.indexWhere((e) =>
              e.mealId == list[i]?.mealId &&
              ((e.mealProvidedCount ?? 0) >= (e.mealAllocatedCount ?? 0))) !=
          -1) {
        EasyLoading.showInfo('${list[i]?.mealDes} is over');
        // _selectedMealsList.removeAt(i);
        _selectedMealsList
            .removeWhere((e) => e?.mealId == res?.mealsummaryitems?[i].mealId);
      }
    }

    if (_selectedMealsList.isEmpty) {
      EasyLoading.showInfo(
          'One of the selected meal is over \nPlease re-select meals');
      return;
    }
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    // if (barcodeScanRes == '-1') {
    //   return;
    // }

    if (barcodeScanRes == '-1') return;

// 🔴 Prevent immediate duplicate scan
    if (_lastScannedBarcode == barcodeScanRes) {
      playRejectSound();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Already Scanned", style: TextStyle(color: Colors.red)),
          content: Text(
            "This barcode was already scanned.\nPlease scan a different barcode.",
            style: CustomTextStyles.titleMedium2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Handle the scanned barcode result as you wish
    print(barcodeScanRes);

    if (barcodeScanRes.startsWith("userId")) {
      final String userId = barcodeScanRes.split(":")[1];

      final result = await MealController().updateStaffMealPlan(
        userId: userId,
        mealId: _selectedMealsList
            .map((summaryItem) => summaryItem?.mealId ?? '')
            .toList(),
        supplierId: COMMON.USERID,
      );
      if (result != null) {
        for (int i = 0; i < result.mealcardItems!.length; i++) {
          int? status = result.mealcardItems![i].status;
          print("The status:${result.mealcardItems![i].status}");

          // if (status == 1) {
          //   playAcceptedSound();
          //   Future.delayed(Duration(seconds: 2), () {
          //     Navigator.of(context).pop(true);
          //   });
          //   await showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: Text(
          //           "Update Successfully",
          //           style: TextStyle(color: Colors.green),
          //         ),
          //         content: Text(
          //           "${result.mealcardItems![i].message}",
          //           style: CustomTextStyles.titleMedium2,
          //         ),
          //         actions: <Widget>[
          //           TextButton(
          //             onPressed: () async {
          //               // Navigator.of(context).pop();
          //               Navigator.pop(context);

          //               // Dismiss dialog
          //               // Continue scanning after dismissing the dialog
          //             },
          //             child: Center(child: Text("OK")),
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // }
          if (status == 1) {
            playAcceptedSound();

            _lastScannedBarcode = barcodeScanRes; // remember barcode
            _isDialogOpen = true;

            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text(
                  "Update",
                  style: TextStyle(color: Colors.green),
                ),
                content: Text(
                  result.mealcardItems![i].message ?? '',
                  style: CustomTextStyles.titleMedium2,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Center(child: Text("OK")),
                  ),
                ],
              ),
            );

            _isDialogOpen = false;

            /// ✅ ALLOW NEXT SCAN (continuous scanning)
            if (mounted) {
              await Future.delayed(const Duration(milliseconds: 300));
              await _scanBarcode(context);
            }
            return;
          } else if (status == 0) {
            playRejectSound();

            //  _showToast("Failed:${result.mealcardItems![i].message}");
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Invalid QR Code",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    "${result.mealcardItems![i].message}",
                    style: CustomTextStyles.titleMedium2,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        // Navigator.of(context).pop(); // Dismiss dialog
                        // Continue scanning after dismissing the dialog
                      },
                      child: Center(child: Text("OK")),
                    ),
                  ],
                );
              },
            );
            // await _scanBarcode(context);
          } else {
            playRejectSound();
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Invalid QR Code",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    "The scanned QR code is invalid. Please try again.",
                    style: CustomTextStyles.titleMedium2,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // Navigator.of(context).pop(); // Dismiss dialog
                        // Continue scanning after dismissing the dialog
                      },
                      child: Center(child: Text("OK")),
                    ),
                  ],
                );
              },
            );
            // await _scanBarcode(context);
          }
        }
        // await _scanBarcode(context);
        if (mounted) {
          await _scanBarcode(context);
        }
      }

      //await _scanBarcode(context);
    } else {
      playRejectSound();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Invalid QR Code",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "The scanned QR code is invalid. Please try again.",
              style: CustomTextStyles.titleMedium2,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Navigator.of(context).pop(); // Dismiss dialog
                  // Continue scanning after dismissing the dialog
                },
                child: Center(child: Text("OK")),
              ),
            ],
          );
        },
      );
      // await _scanBarcode(context);
      if (mounted) {
        await _scanBarcode(context);
      }
    }
  }

  // Future<void> _scanBarcode(BuildContext context) async {
  //   /// 🔴 VALIDATION: No meal selected
  //   if (_selectedMealsList.isEmpty) {
  //     playRejectSound();
  //     EasyLoading.showError(
  //       'Please select a meal before scanning.',
  //     );
  //     return;
  //   }

  //   /// 🔴 VALIDATION: Multiple meals selected
  //   if (_selectedMealsList.length > 1) {
  //     playRejectSound();
  //     EasyLoading.showError(
  //       'Multiple meals selected.\nPlease select only ONE meal to scan.',
  //     );
  //     return;
  //   }

  //   /// 🔹 Fetch day meal summary
  //   var res = await MealController().fetchDayMealSummary(selectedDate);

  //   List list = [];
  //   list.addAll(_selectedMealsList);

  //   for (int i = 0; i < list.length; i++) {
  //     final index = res?.mealsummaryitems?.indexWhere(
  //       (e) =>
  //           e.mealId == list[i]?.mealId &&
  //           ((e.mealProvidedCount ?? 0) >= (e.mealAllocatedCount ?? 0)),
  //     );

  //     if (index != null && index != -1) {
  //       EasyLoading.showInfo('${list[i]?.mealDes} is over');

  //       _selectedMealsList.removeWhere(
  //         (e) => e?.mealId == res?.mealsummaryitems?[index].mealId,
  //       );
  //     }
  //   }

  //   if (_selectedMealsList.isEmpty) {
  //     EasyLoading.showInfo(
  //       'Selected meal is over.\nPlease re-select a meal.',
  //     );
  //     return;
  //   }

  //   /// 🔹 Scan QR Code
  //   String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //     '#ff6666',
  //     'Cancel',
  //     true,
  //     ScanMode.QR,
  //   );

  //   if (barcodeScanRes == '-1') {
  //     return;
  //   }

  //   print(barcodeScanRes);

  //   /// 🔴 INVALID QR FORMAT
  //   if (!barcodeScanRes.startsWith("userId")) {
  //     playRejectSound();

  //     await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(
  //           "Invalid QR Code",
  //           style: TextStyle(color: Colors.red),
  //         ),
  //         content: Text(
  //           "The scanned QR code is invalid. Please try again.",
  //           style: CustomTextStyles.titleMedium2,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Center(child: Text("OK")),
  //           ),
  //         ],
  //       ),
  //     );

  //     await _scanBarcode(context);
  //     //return;
  //   }

  //   /// 🔹 Extract userId
  //   final String userId = barcodeScanRes.split(":")[1];

  //   /// 🔹 API Call
  //   final result = await MealController().updateStaffMealPlan(
  //     userId: userId,
  //     mealId: [_selectedMealsList.first?.mealId ?? ''],
  //     supplierId: COMMON.USERID,
  //   );

  //   if (result == null) return;

  //   for (int i = 0; i < result.mealcardItems!.length; i++) {
  //     int? status = result.mealcardItems![i].status;
  //     print("The status: $status");

  //     /// ✅ SUCCESS
  //     if (status == 1) {
  //       playAcceptedSound();

  //       Future.delayed(const Duration(seconds: 2), () {
  //         Navigator.of(context).pop(true);
  //       });

  //       await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text(
  //             "Update Successfully",
  //             style: TextStyle(color: Colors.green),
  //           ),
  //           content: Text(
  //             result.mealcardItems![i].message ?? '',
  //             style: CustomTextStyles.titleMedium2,
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Center(child: Text("OK")),
  //             ),
  //           ],
  //         ),
  //       );
  //     }

  //     /// ❌ FAILED
  //     else {
  //       playRejectSound();

  //       await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text(
  //             "Invalid QR Code",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           content: Text(
  //             result.mealcardItems![i].message ??
  //                 "The scanned QR code is invalid.",
  //             style: CustomTextStyles.titleMedium2,
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Center(child: Text("OK")),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }

  //   /// 🔁 Continue scanning
  //   await _scanBarcode(context);
  // }

  Future<void> updateStaffMealPlan(String responseQR) async {
    // if (_selectedMealsList.isNotEmpty) {
    //   focusNode.requestFocus();
    // }
    print(responseQR);

    if (responseQR.startsWith("userId")) {
      final String userId = responseQR.split(":")[1];
//
      final result = await MealController().updateStaffMealPlan(
        userId: userId,
        mealId: _selectedMealsList
            .map((summaryItem) => summaryItem?.mealId ?? '')
            .toList(),
        supplierId: COMMON.USERID,
      );
      if (result != null) {
        for (int i = 0; i < result.mealcardItems!.length; i++) {
          int? status = result.mealcardItems![i].status;
          print("The status:${result.mealcardItems![i].status}");

          if (status == 1) {
            playAcceptedSound();

            // _showToast("${result.mealcardItems![i].message}");
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 2), () {
                  if (Navigator.of(context).canPop()) {
                    barcodeCtrl.clear();
                    Navigator.of(context)
                        .pop(); // Dismiss dialog after 10 seconds
                  }
                });
                return AlertDialog(
                  title: Text(
                    "Successfully Updated",
                    style: TextStyle(color: Colors.green),
                  ),
                  content: Text(
                    "${result.mealcardItems![i].message}",
                    style: CustomTextStyles.titleMedium2,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        barcodeCtrl.clear();
                        Navigator.of(context).pop(); // Dismiss dialog
                        // Continue scanning after dismissing the dialog
                      },
                      child: Center(child: Text("OK")),
                    ),
                  ],
                );
              },
            );
          } else if (status == 0) {
            playRejectSound();

            //  _showToast("Failed:${result.mealcardItems![i].message}");
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 30), () {
                  if (Navigator.of(context).canPop()) {
                    barcodeCtrl.clear();
                    Navigator.of(context)
                        .pop(); // Dismiss dialog after 10 seconds
                  }
                });
                return AlertDialog(
                  title: Text(
                    "Invalid QR Code",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    "${result.mealcardItems![i].message}",
                    style: CustomTextStyles.titleMedium2,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        barcodeCtrl.clear();
                        Navigator.of(context).pop(); // Dismiss dialog
                        // Continue scanning after dismissing the dialog
                      },
                      child: Center(child: Text("OK")),
                    ),
                  ],
                );
              },
            );
          } else {
            playRejectSound();

            await showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 30), () {
                  if (Navigator.of(context).canPop()) {
                    barcodeCtrl.clear();
                    Navigator.of(context)
                        .pop(); // Dismiss dialog after 10 seconds
                  }
                });
                return AlertDialog(
                  title: Text(
                    "Invalid QR Code",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    "The scanned QR code is invalid. Please try again.",
                    style: CustomTextStyles.titleMedium2,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        barcodeCtrl.clear();

                        Navigator.of(context).pop(); // Dismiss dialog
                        // Continue scanning after dismissing the dialog
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
    } else {
      playRejectSound();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // Future.delayed(Duration(seconds: 30), () {
          //   if (Navigator.of(context).canPop()) {
          //     barcodeCtrl.clear();
          //     Navigator.of(context).pop(); // Dismiss dialog after 10 seconds
          //   }
          // });
          return AlertDialog(
            title: Text(
              "Invalid QR Code",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "The scanned QR code is invalid. Please try again.",
              style: CustomTextStyles.titleMedium2,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  barcodeCtrl.clear();

                  Navigator.of(context).pop(); // Dismiss dialog
                  // Continue scanning after dismissing the dialog
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
            onTap: () async {
              await mealBloc.addMealSummaryResult(DateTime.now());
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, AppRoutes.supplerScreen);
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
                              //    COMMON.timer?.cancel();
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

////
