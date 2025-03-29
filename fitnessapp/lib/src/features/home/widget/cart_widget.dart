import 'dart:math';

import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/constant/fitbitconst.dart';
import 'package:FitTrack/src/common/utils/custom_cotainer.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CartWidget extends StatelessWidget {
  final Widget iconWidget;
  const CartWidget(
      {super.key,
      required this.iconWidget,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth / 2.3,
      height: 220.h,
      child: Stack(
        children: [
          CustomContainer(
           boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.6),
                          blurRadius: 4,
                          offset: Offset(.5, 1))
                    ],
            height: 220.h,
            width: ScreenUtil().screenWidth / 2.3,
            color: AppColors.cardbgColor,
            borderRadius: 20.r,
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: CircularPercentIndicator(
                reverse: true,
                radius: 60.r,
                lineWidth: 6.w,
                startAngle: 50,
                percent: min(FitBitConst.stepsdataList![0].value! / 5000, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FitBitConst.stepsdataList![0].value!.toInt().toString(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.txtColor,
                      ),
                    ),
                    Text(
                      "Steps",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.txtColor,
                      ),
                    ),
                  ],
                ),
                progressColor: AppColors.primaryColor,
                backgroundColor: Colors.black.withOpacity(.1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Walk',
                  fontSize: 13.sp,
                  color: AppColors.txtColor,
                ),
                iconWidget
              ],
            ),
          )
        ],
      ),
    );
  }
}
