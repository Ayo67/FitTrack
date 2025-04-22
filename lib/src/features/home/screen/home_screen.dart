import 'dart:developer';

import 'package:fitnessapp/src/common/constant/app_image.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/formate_dates.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:fitnessapp/src/features/home/controller/homecontroller.dart';
import 'package:fitnessapp/src/features/home/widget/cart_widget.dart';
import 'package:fitnessapp/src/features/sleep/sleep.dart';
import 'package:fitnessapp/src/repository/fitbit_repo.dart';
import 'package:fitnessapp/src/repository/fitbitmap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Homecontroller.to;
  static bool isFetched = false; // This persists across widget rebuilds
  Future<void> _pickDate(BuildContext context, String dateType) async {
    final controller = BottomBarController.to;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(this.controller.startDate.value),
      firstDate: DateTime(2000), // Set the minimum date
      lastDate: DateTime.now(), // Set the maximum date
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // header background color
              onPrimary: AppColors.cardbgColor, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // backgroundColor: Colors.black,
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.isLoading.value = true;
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      if (dateType == 'start') {
        this.controller.startDate.value = formattedDate;
      }

      var n = await Future.wait([
        FitBitRepo().fetchFitbitCalories(
            startDate: pickedDate.subtract(Duration(days: 1)),
            endDate: pickedDate),
        FitBitRepo().fetchFitbitHeartRate(date: pickedDate),
        FitBitRepo().fetchFitbitSleep(date: pickedDate),
        FitBitRepo().fetchFitbitSteps(
            startDate: pickedDate.subtract(Duration(days: 1)),
            endDate: pickedDate),
      ]);

      if (n.isNotEmpty) {
        controller.isLoading.value = false;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (!isFetched) {
      FitBitRepo()
          .fetchFitbitSleepWeekly()
          .catchError((e) => log("Error fetching profile: $e"));
      FitBitRepo().refreshtoken();
      print("Fetched only 1 time");
      isFetched = true;
    }
  }

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
                  backgroundColor: AppColors.btnColor,
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
                      text: 'Hello !',
                      fontSize: 14.sp,
                      color: AppColors.txtColor,
                    ),
                    Obx(() {
                      return TextWidget(
                        text: FitBitConst.usesrData!.value.fullName.toString(),
                        fontSize: 14.sp,
                        color: AppColors.txtColor,
                        fontWeight: FontWeight.w500,
                      );
                    }),
                  ],
                ),
                Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     // Get.to(NotificationScreen());
                //     Get.to(FitbitMapScreen());
                //   },
                //   child: Container(
                //     height: 50.h,
                //     width: 50.w,
                //     decoration: BoxDecoration(
                //         border:
                //             Border.all(color: AppColors.primaryColor, width: 1),
                //         color: Color(0xff171624),
                //         shape: BoxShape.circle),
                //     child: Icon(
                //       Icons.notifications_none_outlined,
                //       color: AppColors.whiteColor,
                //       size: 30.h,
                //     ),
                //   ),
                // )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: "Today's Summary",
                      fontSize: 20.sp,
                      color: AppColors.txtColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomContainer(
                    onTap: () {
                      _pickDate(context, 'start');
                      log('---');
                    },
                    borderRadius: 8.r,
                    color: AppColors.primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: AppColors.txtColor,
                          size: 20.h,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.txtColor,
                          size: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Obx(() {
                          return TextWidget(
                            text: controller.startDate.value,
                            fontSize: 12.sp,
                            color: AppColors.txtColor,
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CartWidget(
                    iconWidget: Icon(
                      Icons.directions_run_outlined,
                      color: AppColors.txtColor,
                    ),
                    // centerWidget: CustomContainer(
                    //   boxShadow: [
                    //     BoxShadow(
                    //         color: AppColors.black,
                    //         blurRadius: 4,
                    //         offset: Offset(.5, 1))
                    //   ],
                    //   height: 220.h,
                    //   width: ScreenUtil().screenWidth / 2.5,
                    //   color: AppColors.cardbgColor,
                    //   borderRadius: 20.r,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(top: 15.h),
                    //     child: CircularPercentIndicator(
                    //       reverse: true,
                    //       radius: 60.r,
                    //       lineWidth: 6.w,
                    //       startAngle: 50,
                    //       percent: .65,
                    //       center: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             FitBitConst.stepsdataList![0].value!.toInt()
                    //                 .toString(),
                    //             style: TextStyle(
                    //               fontSize: 20.sp,
                    //               fontWeight: FontWeight.bold,
                    //               color: AppColors.txtColor,
                    //             ),
                    //           ),
                    //           Text(
                    //             "Steps",
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: AppColors.txtColor,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       progressColor: AppColors.primaryColor,
                    //       backgroundColor: Colors.black,
                    //       circularStrokeCap: CircularStrokeCap.round,
                    //     ),
                    //   ),
                    // ),
                  ),
                  SizedBox(),
                  CustomContainer(
                    // color: AppColors.cardColor,
                    color: AppColors.cardbgColor,
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
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: (FitBitConst.heartRateData!
                                              .restingHeartRate ??
                                          0)
                                      .toString(),
                                  fontSize: 16.sp,
                                  color: AppColors.txtColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: 'bmp',
                                  fontSize: 14.sp,
                                  color: AppColors.txtColor,
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
                                color: AppColors.txtColor,
                              ),
                              Icon(
                                Icons.favorite,
                                color: AppColors.black,
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
                    color: AppColors.cardbgColor,
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
                              Obx(() => !controller.loadchart.value
                                  ? SizedBox(
                                      height: 150.h,
                                      child: BarChart(
                                        BarChartData(
                                          borderData: FlBorderData(show: false),
                                          gridData: FlGridData(show: false),
                                          titlesData: FlTitlesData(
                                            show:
                                                false, // hides axis titles & labels
                                          ),
                                          barGroups: _buildBarData(),
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY:
                                              16, // maximum value for the y-axis
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 150.h,
                                      child: Center(
                                          child: SpinKitFadingFour(
                                              color: AppColors.primaryColor,
                                              size: 100.0)))),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text:
                                      Formatesdates.getFormattedDurationMinutes(
                                          minutes: FitBitConst.sleepData!
                                              .summary.totalMinutesAsleep),
                                  fontSize: 16.sp,
                                  color: AppColors.txtColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: 5.w),
                              //   child: TextWidget(
                              //     text: 'Hours',
                              //     fontSize: 14.sp,
                              //     color: AppColors.txtColor,
                              //   ),
                              // ),
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
                                color: AppColors.txtColor,
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => SleepTrackerScreen(),
                                      transition: Transition.rightToLeft);
                                },
                                icon: Icon(
                                  Icons.dark_mode,
                                  color: AppColors.black,
                                ),
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
                    color: AppColors.cardbgColor,
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
                                color: AppColors.txtColor,
                              ),
                              Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Image.asset(
                                    AppImage.fireImage,
                                    color: AppColors.black,
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
                                  text: FitBitConst.caloriesdataList![0].value!
                                      .toInt()
                                      .toString(),
                                  fontSize: 16.sp,
                                  color: AppColors.txtColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: TextWidget(
                                  text: 'kcal',
                                  fontSize: 14.sp,
                                  color: AppColors.txtColor,
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
    final List<double> barValues = FitBitConst.sleepWeaklyData!;

    return barValues.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: AppColors.primaryColor,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
