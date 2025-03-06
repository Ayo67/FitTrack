import 'package:FitTrack/src/common/constant/app_image.dart';
import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/custom_cotainer.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:FitTrack/src/features/home/widget/cart_widget.dart';
import 'package:FitTrack/src/features/notification_screen/page/notification_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff171624),
                  radius: 25.r,
                  child: Icon(
                    Icons.person,
                    color: AppColors.whiteColor,
                    size: 30.h,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Hello User',
                      fontSize: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(NotificationScreen());
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.primaryColor, width: 1),
                        color: Color(0xff171624),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.whiteColor,
                      size: 30.h,
                    ),
                  ),
                )
              ],
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 140.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                        colors: [Color(0xff3d6bc3), Color(0xff06c0fd)])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Your Fitness, Your Way:',
                          fontSize: 13.sp,
                        ),
                        TextWidget(
                          text: 'Track,Train,and \nTransform',
                          fontWeight: FontWeight.w800,
                          fontSize: 17.sp,
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                    SizedBox(
                      // height: 130.h,
                      // width: 80.w,
                      child: Image.asset(
                        AppImage.fitnessWomen,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: "Today's Summary",
                  fontSize: 20.sp,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CartWidget(
                      text: 'Walk',
                      iconWidget: Icon(
                        Icons.directions_run_outlined,
                        color: AppColors.primaryColor,
                      ),
                      centerWidget: CustomContainer(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.primaryColor.withOpacity(.6),
                              blurRadius: 4,
                              offset: Offset(.5, 1))
                        ],
                        height: 220.h,
                        width: ScreenUtil().screenWidth / 2.5,
                        color: AppColors.cardColor,
                        borderRadius: 20.r,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: CircularPercentIndicator(
                            reverse: true,
                            radius: 60.r,
                            lineWidth: 6.w,
                            startAngle: 50,
                            percent: .65,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1046",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Steps",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            progressColor: AppColors.primaryColor,
                            backgroundColor: Colors.black,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ),
                      )),
                  SizedBox(),
                  CustomContainer(
                    // color: AppColors.cardColor,
                    color: AppColors.cardColor,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.6),
                          blurRadius: 4,
                          offset: Offset(.5, 1))
                    ],
                    borderRadius: 20.r,
                    width: ScreenUtil().screenWidth / 2.3,
                    height: 220.h,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              SizedBox(
                                height: 120.h,
                                child: Center(
                                  child: Image.asset(
                                    AppImage.linearGraph,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: '96',
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: 'bmp',
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: 'Heart',
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                              Icon(
                                Icons.favorite,
                                color: AppColors.primaryColor.withOpacity(.6),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomContainer(
                    // color: AppColors.cardColor,
                    color: AppColors.cardColor,
                    borderRadius: 20.r,
                    width: ScreenUtil().screenWidth / 2.3,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.6),
                          blurRadius: 4,
                          offset: Offset(.5, 1))
                    ],

                    height: 220.h,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 150.h,
                                child: BarChart(
                                  BarChartData(
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(show: false),
                                    titlesData: FlTitlesData(
                                      show: false, // hides axis titles & labels
                                    ),
                                    barGroups: _buildBarData(),
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: 16, // maximum value for the y-axis
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: '6',
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: 'Hours',
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: 'Sleep',
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                              Icon(
                                Icons.dark_mode,
                                color: AppColors.primaryColor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(),
                  CustomContainer(
                    // color: AppColors.cardColor,
                    color: AppColors.cardColor,
                    borderRadius: 20.r,
                    width: ScreenUtil().screenWidth / 2.3,
                    height: 220.h,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.6),
                          blurRadius: 4,
                          offset: Offset(.5, 1))
                    ],

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: 'Calories',
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                              Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Image.asset(
                                    AppImage.fireImage,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: SizedBox(
                                height: 100.h,
                                child: Image.asset(
                                  AppImage.fireImage,
                                  color: AppColors.primaryColor,
                                )),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: '400',
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: 'kcal',
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarData() {
    final List<double> barValues = [5, 8, 6, 7, 3, 9, 4];

    return barValues.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Colors.cyan,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
