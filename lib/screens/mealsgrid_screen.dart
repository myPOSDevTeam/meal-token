import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jkh_mealtoken/components/widgets/Alert.dart';
import 'package:jkh_mealtoken/components/widgets/custom_elevated_button.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/controllers/meal_controller.dart';
import 'package:jkh_mealtoken/models/common.dart';
import 'package:jkh_mealtoken/models/meal_image_result.dart';
import 'package:jkh_mealtoken/models/supplier_mealcard_results.dart';

class MealGridScreen extends StatefulWidget {
  final String? userId;
  MealCardResult? mealCardResult;
  MealGridScreen({Key? key, required this.userId, required this.mealCardResult})
      : super(
          key: key,
        );

  @override
  State<MealGridScreen> createState() => _MealGridScreenState();
}

class _MealGridScreenState extends State<MealGridScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MealCardItem?> _selectedMealsList = [];

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
                'Do you want to go back ?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.045),
                // style: CustomTextStyles.titleMedium2,
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
            Navigator.pushNamed(context, AppRoutes.homeScreen);
          }
        }
      },
      child: SafeArea(
          child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 160, 206, 243).withOpacity(0.1),
        backgroundColor: Color.fromARGB(255, 255, 239, 99).withOpacity(0.1),
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 11.h,
                          right: 66.h,
                        ),
                        child: Text(
                          "Select the Meal\nPlan",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.userId == '')
                CircularProgressIndicator()
              else
                // FutureBuilder<MealCardResult?>(
                //     future: MealController().fetchMealPlans(widget.userId ??
                //         ""), // Use the fetchMealPlans method here
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         // If the data is still loading, show a loading indicator
                //         return CircularProgressIndicator();
                //       } else if (snapshot.hasError) {
                //         // If there's an error, display an error message
                //         return Text('Error: ${snapshot.error}');
                //       } else {
                //         // if (snapshot.hasData) {
                //         // If data is successfully loaded, display the meal plans
                //         final mealCardResult = snapshot.data;
                //         if (mealCardResult != null &&
                //             mealCardResult.success == true) {
                //           // If the request was successful and there are meal items, display them
                //           //
                //           return
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 6.0,
                            mainAxisSpacing: 6.0,
                          ),
                          itemCount:
                              widget.mealCardResult?.mealcardItems?.length ?? 0,
                          itemBuilder: (BuildContext contxt, int index) {
                            final mealItem =
                                widget.mealCardResult?.mealcardItems![index];
                            String mealImage =
                                (COMMON.allMeals?.imageItems?.firstWhere(
                                              (element) =>
                                                  element.mealID ==
                                                  mealItem!.mealID,
                                              orElse: () =>
                                                  ImageItem(mealImage: ''),
                                            ) ??
                                            ImageItem(mealImage: ''))
                                        .mealImage ??
                                    '';
                            Uint8List imgByte = base64Decode(mealImage);
                            var a = _selectedMealsList.indexWhere(
                                (element) =>
                                    element?.mealID == mealItem!.mealID,
                                -1);

                            if (mealItem!.mealisEligible == true &&
                                mealItem.mealisProvided == false) {
                              return CustomCard(
                                byte: imgByte,
                                isSelected: a != -1,
                                // imageUrl: ImageConstant
                                //     .imgUnsplashY6a9bhilkm108x110,
                                mealName: mealItem.mealName ?? "",
                                onTap: () {
                                  setState(() {
                                    if (a != -1) {
                                      _selectedMealsList.removeAt(a);
                                    } else {
                                      _selectedMealsList.add(mealItem);
                                    }
                                  });
                                },
                              );
                            } else if (mealItem.mealisProvided == true) {
                              return CustomCard(
                                mealName: '${mealItem.mealName} is Provided',
                                isSelected: false,
                                onTap: () {},
                                byte: imgByte,
                                // imageUrl: ImageConstant
                                //     .imgUnsplashY6a9bhilkm108x110,
                              );

                              // Text('No Meal Plan Available');
                              // return Center(
                              //   child: TextButton(
                              //     child: Text('Re Scan'),
                              //     onPressed: () => {},
                              //   ),
                              // );
                            } else {
                              return CustomCard(
                                mealName:
                                    'Not Eligible For ${mealItem.mealName}',
                                isSelected: false,
                                onTap: () {},
                                byte: imgByte,
                                // imageUrl: ImageConstant
                                // .imgUnsplashY6a9bhilkm108x110,
                              );
                            }
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(15.0),
                      //   child: CustomElevatedButton(
                      //     height: 66.v,
                      //     text: "Submit",
                      //     onPressed: () async {
                      //       if (_selectedMealsList != null) {
                      //         //create update method in meal controller class

                      //         final result = await MealController()
                      //             .updateStaffMealPlan(
                      //                 userId: widget.userId,
                      //                 mealId: List.generate(
                      //                     _selectedMealsList.length,
                      //                     (index) =>
                      //                         _selectedMealsList[index]
                      //                             ?.mealID ??
                      //                         ''), //_selectedMeal!.mealID,
                      //                 supplierId: COMMON.USERID);

                      //         if (result != null) {
                      //           showDialog(
                      //               context: context,
                      //               builder: (BuildContext context) {
                      //                 return AlertDialog(
                      //                   title: Text('Success'),
                      //                   content: Text(
                      //                       'Meal plan updated Successfully'),
                      //                   actions: [
                      //                     TextButton(
                      //                         onPressed: () {
                      //                           // Navigator.of(context)
                      //                           //     .pop();
                      //                           Navigator
                      //                               .pushReplacementNamed(
                      //                                   context,
                      //                                   AppRoutes
                      //                                       .homeScreen);
                      //                         },
                      //                         child: Text('Ok'))
                      //                   ],
                      //                 );
                      //               });
                      //         }
                      //       }
                      //     },
                      //   ),
                      // )

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomElevatedButton(
                          height: 66.v,
                          text: "Submit",
                          onPressed: () async {
                            if (_selectedMealsList.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                      'Do you want to update the meal plan?',
                                      style: CustomTextStyles.titleMedium2,
                                    ),
                                    actions: [
                                      // TextButton(
                                      //   onPressed: () async {
                                      //     // Navigator.of(context)
                                      //     //     .pop(); // Close the dialog
                                      //     final result = await MealController()
                                      //         .updateStaffMealPlan(
                                      //       userId: widget.userId,
                                      //       mealId: _selectedMealsList
                                      //           .map((mealItem) =>
                                      //               mealItem?.mealID ?? '')
                                      //           .toList(),
                                      //       supplierId: COMMON.USERID,
                                      //     );
                                      //     if (result != null) {
                                      //       Navigator.pushReplacementNamed(
                                      //         context,
                                      //         AppRoutes.homeScreen,
                                      //       );
                                      //     }
                                      //   },
                                      //   child: Text('Yes'),
                                      // ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Navigator.of(context)
                                          //     .pop(); // Close the dialog
                                          final result = await MealController()
                                              .updateStaffMealPlan(
                                            userId: widget.userId,
                                            mealId: _selectedMealsList
                                                .map((mealItem) =>
                                                    mealItem?.mealID ?? '')
                                                .toList(),
                                            supplierId: COMMON.USERID,
                                          );
                                          if (result != null) {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              AppRoutes.homeScreen,
                                            );
                                          }
                                        },
                                        child: Text('Yes',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      CustomElevatedButton(
                                        // style: ButtonStyle(
                                        //   // maximumSize: 20
                                        // ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        text: 'No',

                                        // child: Text('No',
                                        //     style:
                                        //         TextStyle(color: Colors.white)),
                                      )
                                      // TextButton(
                                      //   onPressed: () {
                                      //     Navigator.of(context)
                                      //         .pop(); // Close the dialog
                                      //   },
                                      //   child: Text('No'),
                                      // ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Show error message if no meals are selected

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Please select at least one meal.',
                                      style: CustomTextStyles.titleMedium2,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'),
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),

              //update
              //SizedBox(height: 60.v),

              CustomImageView(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                imagePath: ImageConstant.imgPowered2,
                height: 56.v,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class CustomCard extends StatefulWidget {
  // final String imageUrl;
  final Uint8List byte;
  final String mealName;
  final bool isSelected;
  final VoidCallback? onTap;

  const CustomCard({
    required this.mealName,
    required this.isSelected,
    required this.onTap,
    required this.byte,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 100,
        child: Card(
          color: widget.isSelected ? Color(0XFFD83F31) : Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: widget.byte.length == 0
                        ? Image.asset('assets/images/image_not_found.png')
                        : Image.memory(widget.byte)
                    // child: CachedNetworkImage(
                    //   imageUrl: widget.imageUrl, // Set the parsed URL here
                    //   width: 50,
                    //   height: 50,
                    //   fit: BoxFit.cover,
                    //   placeholder: (context, url) => CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.mealName,
                  style: TextStyle(
                    color: (widget.mealName.contains('Not') ||
                            widget.mealName.contains('Provided'))
                        ? Colors.red
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class QRAlertDialog extends StatefulWidget {
//   final String qrData;

//   const QRAlertDialog({required this.qrData});

//   @override
//   State<QRAlertDialog> createState() => _QRAlertDialogState();
// }

// class _QRAlertDialogState extends State<QRAlertDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('QR Code'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           QrImageView(
//             data: widget.qrData,
//             version: QrVersions.auto,
//             size: 200.0,
//           ),
//           SizedBox(height: 20),
//           Text('Scan the QR code'),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
// }
