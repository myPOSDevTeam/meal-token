import 'dart:async';
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jkh_mealtoken/components/widgets/Alert.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/components/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';
import 'package:jkh_mealtoken/models/staff_mealcard_results.dart';
import 'package:jkh_mealtoken/screens/profile.dart';
import 'package:jkh_mealtoken/screens/user_login.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScreenoneScreen extends StatefulWidget {
  const ScreenoneScreen({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<ScreenoneScreen> createState() => _ScreenoneScreenState();
}

class _ScreenoneScreenState extends State<ScreenoneScreen> {
 // DateTime? _lastActiveTime;
  final storage = FlutterSecureStorage();

  //static const sessionTimeout = Duration(hours: 23);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ImageResult? allMeals;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _lastActiveTime = DateTime.now();
    // startSessionTimer();
    checkSession();
    // fetchMeals();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showDialog(
            context: context,
            builder: (BuildContext context) => QRAlertDialog(
                  qrData: 'userId:${COMMON.USERID}',
                ));
      },
    );
  }

  // void fetchMeals() async {
  //   allMeals = await MealController().fetchMealImage();
  // }

  // void startSessionTimer() {
  //   COMMON.timer = Timer(sessionTimeout, () async {
  //     if (DateTime.now().difference(_lastActiveTime!) > sessionTimeout) {
  //       await showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text(
  //                 'Session Expired Login Again',
  //               ),
  //               actions: [
  //                 Center(
  //                   child: ElevatedButton(
  //                     child: Text(
  //                       'ok',
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
  void checkSession()async  {
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

  void _logout() async {
    // Clear any stored user credentials
    await storage.deleteAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<bool> checkTokenExpired() async {
    String? token = await storage.read(key: 'accessToken');
    final jwt = JWT.decode(token ?? '');
    var body = jwt.payload;
    int exp = body['exp'];

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    return DateTime.now().isAfter(dateTime);
  }

//kjjjkj
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
                          // fontFamily: "Century Gothic",
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
          // backgroundColor: Color.fromARGB(255, 160, 206, 243).withOpacity(0.1),
          backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
          key: _scaffoldKey,
          endDrawer: MyDrawer(),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                // SizedBox(height: 40.v),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            //width: 272.h,
                            margin: EdgeInsets.only(
                              left: 11.h,
                              right: 66.h,
                            ),
                            child: Text("Today Yours Meal\n Plans",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.appbartitle),
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState?.openEndDrawer();
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    size: 30,
                                  )),
                              // CustomImageView(
                              //   imagePath: ImageConstant.imgRectangle31,
                              //   height: 40.v,0;
                              //   radius: BorderRadius.circular(
                              //     10.h,
                              //   ),
                              //   onTap: () {
                              // _scaffoldKey.currentState
                              //     ?.openEndDrawer(); // Navigator.push(
                              //     //     context,
                              //     //     MaterialPageRoute(
                              //     //         builder: (context) => MyDrawer()));
                              //     //AppRoutes.profileScreen;
                              //   },
                              // ),
                              // Text(COMMON.USERID,
                              //     style: CustomTextStyles.titleMedium1)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<StaffMealCardResult?>(
                          future: MealController().fetchStaffMealPlans(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              //Text('Error:${snapshot.error}');
                              return ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    MealController().fetchStaffMealPlans();
                                  });
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Refresh',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            } else {
                              final staffmealCardResult = snapshot.data;

                              if (staffmealCardResult != null &&
                                  staffmealCardResult.success == true) {
                                return Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: staffmealCardResult
                                                .mealcardItems?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final mealItem = staffmealCardResult
                                              .mealcardItems![index];
                                          String mealImage = (COMMON
                                                          .allMeals?.imageItems
                                                          ?.firstWhere(
                                                        (element) =>
                                                            element.mealID ==
                                                            mealItem.mealID,
                                                        orElse: () => ImageItem(
                                                            mealImage: ''),
                                                      ) ??
                                                      ImageItem(mealImage: ''))
                                                  .mealImage ??
                                              '';
                                          Uint8List imgByte =
                                              base64Decode(mealImage);
                                          return CustomListTile(
                                            // imageUrl:
                                            //     "${ApiClient.baseURL}Image/${mealItem.mealID}",
                                            byte: imgByte,
                                            title: mealItem.mealName ?? "",
                                            subtitle1: mealItem.mealisEligible!
                                                ? (mealItem.isMealProvided!
                                                    ? "Your Meal is Provided"
                                                    : "Available")
                                                : "Not Eligible",
                                            timeperiod: mealItem
                                                            .isMealProvided ==
                                                        false &&
                                                    mealItem.mealisEligible ==
                                                        true
                                                ? "${_formatTime(mealItem.mealfromTime ?? '')} - ${_formatTime(mealItem.mealtoTime ?? '')}"
                                                : "",
                                          );
                                        }));
                              } else {
                                return Text('No meal plans Available');
                                // return ElevatedButton.icon(
                                //   onPressed: () {
                                //     setState(() {
                                //       MealController().fetchStaffMealPlans();
                                //     });
                                //   },
                                //   icon: Icon(
                                //     Icons.refresh,
                                //     color: Colors.black,
                                //   ),
                                //   label: Text(
                                //     'Refresh',
                                //     style: TextStyle(color: Colors.black),
                                //   ),
                                // );
                              }
                            }
                          }),
                      SizedBox(height: 49.v),
                      CustomElevatedButton(
                        text: "Generate Your QR",
                        onPressed: () {
                          //return QRAlertDialog(qrData: qrData)
                          // showBottomSheet(context: context, builder: (context) => QRAlertDialog(
                          //               qrData: '0772066072',
                          //             ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRAlertDialog(
                                        qrData: 'userId:${COMMON.USERID}',
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CustomImageView(
                  imagePath: ImageConstant.imgPowered2,
                  height: 56.v,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // Convert time to 12-hour format
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    //int minute = int.parse(parts[1]);

    // Determine whether it's AM or PM
    String period = hour < 12 ? 'AM' : 'PM';

    // Convert hour to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    // Format the time string
    return '$hour:${parts[1]} $period';
  }

  Future<bool> _onWillPop() async {
    final futureBool = await showDialog(
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
                    // fontFamily: "Century Gothic",
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );

    return (futureBool);
  }
}

class CustomListTile extends StatefulWidget {
  // final String imageUrl;
  final Uint8List byte;
  final String title;
  final String subtitle1;
  final String timeperiod;

  const CustomListTile({
    Key? key,
    required this.byte,
    required this.title,
    required this.subtitle1,
    required this.timeperiod,
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: widget.byte.length == 0
            ? Image.asset('assets/images/image_not_found.png')
            : Image.memory(widget.byte)
        // CachedNetworkImage(
        //   imageUrl: imageUrl, // Set the parsed URL here
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        //   placeholder: (context, url) => CircularProgressIndicator(),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        // )
        ,
        title: Text(widget.title, style: CustomTextStyles.titleMedium7),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.subtitle1,
                  style: (widget.subtitle1.contains("Not") ||
                          widget.subtitle1.contains('Provided'))
                      ? TextStyle(
                          color: Colors.red,
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600)
                      : TextStyle(
                          color: Colors.green,
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              widget.timeperiod,
              style: CustomTextStyles.titleMedium5,
            ),
          ],
        ),
        onTap: () {
          // Do something when the tile is tapped
        },
      ),
    );
  }
}

// class CustomImageListTile extends StatelessWidget {
//   final String title;
//   final String subtitle1;
//   final String timeperiod;

//   const CustomImageListTile({
//     Key? key,
//     required this.title,
//     required this.subtitle1,
//     required this.timeperiod,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       child: FutureBuilder<ImageResult?>(
//           future: MealController().fetchMealImage(),
//           builder: (context, snapshot) {
//             final imageResult = snapshot.data;
//             return ListView.builder(
//                 itemCount: imageResult?.imageItems!.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final imageItem = imageResult?.imageItems![index];
//                   Uint8List bytes = base64.decode(imageItem!.mealImage ?? "");

//                   return ListTile(
//                     leading: Image.memory(
//                       bytes,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(title),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               subtitle1,
//                               style: (subtitle1.contains("Not") ||
//                                       subtitle1.contains('Provided'))
//                                   ? TextStyle(color: Colors.red)
//                                   : TextStyle(color: Colors.green),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           timeperiod,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       // Do something when the tile is tapped
//                     },
//                   );
//                 });
//           }),
//     );
//   }
// }

class CustomCard extends StatefulWidget {
  final String imagePath;
  final String text;

  const CustomCard({required this.imagePath, required this.text});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

bool _isSelected = false;

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Card(
        color: _isSelected ? Colors.red : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRAlertDialog extends StatefulWidget {
  final String qrData;

  const QRAlertDialog({required this.qrData});

  @override
  State<QRAlertDialog> createState() => _QRAlertDialogState();
}

class _QRAlertDialogState extends State<QRAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Center(
        child: AlertDialog(
          title: Text('QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 20),
              Text('Scan the QR code'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
