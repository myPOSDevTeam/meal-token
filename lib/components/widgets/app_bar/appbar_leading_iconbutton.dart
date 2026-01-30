
import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/extentions/app_export.dart';
import 'package:jkh_mealtoken/components/widgets/custom_icon_button.dart';
import 'package:jkh_mealtoken/components/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class AppbarLeadingIconbutton extends StatelessWidget {
  AppbarLeadingIconbutton({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 25.v,
          width: 25.h,
          decoration: IconButtonStyleHelper.outlineYellow,
          child: CustomImageView(
            imagePath: ImageConstant.imgGroup3151,
          ),
        ),
      ),
    );
  }
}
