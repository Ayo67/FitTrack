import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget iconWidget;
  ProfileCardWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.iconWidget});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 150.h,
      width: ScreenUtil().screenWidth / 2.3,
      color: AppColors.cardColor,
      borderRadius: 20.r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          SizedBox(
            height: 12.h,
          ),
          TextWidget(
            text: title,
            fontSize: 16.sp,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 5.h,
          ),
          TextWidget(
            text: subTitle,
            fontSize: 12.sp,
            color: AppColors.whiteColor,
            // fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }
}
