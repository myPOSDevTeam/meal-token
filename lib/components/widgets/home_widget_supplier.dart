import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';

// ignore: must_be_immutable
class HomeItemSupplierWidget extends StatefulWidget {
  // final String imagepath;
  final Uint8List byte;
  final String? mealid;
  final String mealname;
  final String? mealdes;
  final int totcount;
  final int balcount;
  final int servedcount;
  final int staffservedcount;
  final int outsidersservedcount;
  final bool isSelected;
  final VoidCallback? onTap;

  HomeItemSupplierWidget(
      {required this.mealname,
      required this.totcount,
      required this.servedcount,
      required this.balcount,
      required this.staffservedcount,
      required this.outsidersservedcount,
      required this.mealdes,
      required this.mealid,
      required this.byte,
      required this.isSelected,
      this.onTap});

  @override
  State<HomeItemSupplierWidget> createState() => _HomeItemSupplierWidgetState();
}

class _HomeItemSupplierWidgetState extends State<HomeItemSupplierWidget> {
  // final TextStyle textStyle = CurrentTheme.bodyText1!
  //       .copyWith(color: CurrentTheme.accentColor, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.h),
        decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder20,
            color: widget.isSelected
                ? const Color.fromARGB(255, 159, 212, 238)
                : Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: widget.byte.length == 0
                  ? Image.asset('assets/images/image_not_found.png')
                  : Image.memory(widget.byte),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 37.h, top: 8.v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // widget.mealname.length > 20
                      //     ? widget.mealname.substring(0, 20) + '...'
                      //     :
                      widget.mealname,
                      style: widget.mealname.length < 15
                          ? CustomTextStyles.titleMedium4
                          : CustomTextStyles.titleMedium5,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      child: Text(
                        'Total Count: ${widget.totcount}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.titleMediumGray800,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    SizedBox(
                      child: Text(
                        'Served Count: ${widget.servedcount}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.titleMediumGray800,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    SizedBox(
                      child: Text(
                        'Pending Count: ${widget.balcount}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.titleMediumGray800,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Staff: ${widget.staffservedcount}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // style: CustomTextStyles.titleMediumGray800,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Others : ${widget.outsidersservedcount}',
                            // maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                            // style: CustomTextStyles.titleMediumGray800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Spacer(), // This will push the icon to the right end
            Align(
              alignment: Alignment.centerRight,
              child: widget.totcount == widget.servedcount
                  ? Container(
                      width: 20.h,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                            0XFFD83F31), // Adjust the background color if needed
                      ),
                      child: Center(
                        child: Icon(
                          widget.totcount == widget.servedcount
                              ? Icons.check
                              : null,
                          size: 15.h,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
