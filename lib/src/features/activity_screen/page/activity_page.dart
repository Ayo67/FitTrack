import 'dart:developer';

import 'package:fitnessapp/src/common/constant/app_image.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/formate_dates.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/features/activity_screen/controller/activitycontroller.dart';
import 'package:fitnessapp/src/features/activity_screen/page/chart_data.dart';
import 'package:fitnessapp/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:fitnessapp/src/repository/avg_heartrate_model.dart';
import 'package:fitnessapp/src/repository/fitbit_repo.dart';
import 'package:fitnessapp/src/repository/fitbitmap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final controller = Activitycontroller.to;

  @override
  void initState() {
    ChartData().convert(FitBitConst.dataPoints);

    // TODO: implement initState
    super.initState();
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
                  backgroundColor: AppColors.primaryColor,
                  radius: 25.r,
                  child: Icon(
                    Icons.calendar_month,
                    color: AppColors.txtColor,
                    size: 30.h,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Obx(
                   () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: DateFormat('EEEE')
                              .format(DateTime.parse(controller.startDate.value))
                              .toString(),
                          fontSize: 14.sp,
                          color: AppColors.txtColor,
                        ),
                        TextWidget(
                          text: controller.startDate.value ,
                          fontSize: 14.sp,
                          color: AppColors.txtColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    );
                  }
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
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TextWidget(
                  //   text: 'Walk',
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.w600,
                  // ),
                  Obx(
                    () => controller.isActivityFound.value
                        ? SizedBox(
                            width: 200.w,
                            child: DropdownButton<Activity>(
                              hint: controller.dropDownValue.value == null
                                  ? Text('Select Activity')
                                  : Text(
                                      "${controller.dropDownValue.value.activityName}  "
                                      "${Formatesdates.getFormattedStartTime(startTime: controller.dropDownValue.value.startTime)}",
                                      style: TextStyle(
                                          color: AppColors.txtColor,
                                          fontSize: 12.sp),
                                    ),
                              isExpanded: true,
                              iconSize: 30.0.sp,
                              dropdownColor: Colors.white,
                              iconDisabledColor: AppColors.txtColor,
                              iconEnabledColor: AppColors.txtColor,
                              menuMaxHeight: 500.h,
                              // style: TextStyle(color: AppColors.primaryColor),
                              items: FitBitConst.todayActivities!.map(
                                (val) {
                                  return DropdownMenuItem<Activity>(
                                    value: val,
                                    child: Text(
                                      "${val.activityName}  ${Formatesdates.getFormattedStartTime(startTime: val.startTime)}",
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) async {
                                if (val != null) {
                                  FitBitConst.points =
                                      await FitBitRepo.fetchTCXData(
                                          val.logId.toString());
                                  controller.dropDownValue.value = val;
                                }
                              },
                            ),
                          )
                        : SizedBox(),
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
                        Obx(
                         () {
                            return TextWidget(
                              text: controller.startDate.value,
                              fontSize: 12.sp,
                              color: AppColors.txtColor,
                            );
                          }
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => controller.isActivityFound.value
                    ? Column(
                        children: [
                          SizedBox(
                              height: 280.h,
                              width: double.infinity,
                              child: Obx(() {
                                return controller.isLoadingmap.value
                                    ? Text("loading")
                                    : FitbitMapScreen();
                              })),
                          SizedBox(
                            height: 15.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/avgheart.png",
                                  fit: BoxFit.contain,
                                  height: 30.h,
                                  width: 30.w,
                                  color: AppColors.primaryColor,
                                ),
                                Obx(() {
                                  return RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Agerage Heart Rate is :',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: AppColors.txtColor)),
                                    TextSpan(
                                        text:
                                            '   ${controller.dropDownValue.value.averageHeartRate!.toInt()} per minute',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.txtColor,
                                            fontWeight: FontWeight.w700))
                                  ]));
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Activity Levels:",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.txtColor),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Obx(
                                    () {
                                      var activityLevels = controller
                                          .dropDownValue.value.activityLevels;
                                      if (activityLevels == null ||
                                          activityLevels.isEmpty) {
                                        return Text(
                                          " No activity data available",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppColors.txtColor),
                                        );
                                      }
                                      return SizedBox(
                                        height: 100.h,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: activityLevels.length,
                                          itemBuilder: (context, index) {
                                            var activityLevel =
                                                activityLevels[index];
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.h),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80.w,
                                                    child: Text(
                                                      activityLevel.name,
                                                      style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color: index == 0
                                                              ? Color(
                                                                  0xffE0E0E0)
                                                              : index == 1
                                                                  ? AppColors
                                                                      .lightlyActivityColor
                                                                  : index == 2
                                                                      ? AppColors
                                                                          .fairlyActivityColor
                                                                      : AppColors
                                                                          .veryActivityColor),
                                                    ),
                                                  ),
                                                  Text(
                                                    ": ${activityLevel.duration} min",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color:
                                                            AppColors.txtColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_alarms,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Obx(() {
                                return TextWidget(
                                  text: Formatesdates.getFormattedDuration(
                                      duration: controller
                                          .dropDownValue.value.originalDuration!
                                          .toInt()),
                                  fontSize: 13.sp,
                                  color: AppColors.txtColor,
                                );
                              }),
                              Spacer(),
                              Container(
                                height: 25.h,
                                width: 25.w,
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
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Obx(() {
                                return TextWidget(
                                  text: (controller
                                              .dropDownValue.value.calories ??
                                          0)
                                      .toString(),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.txtColor,
                                );
                              }),
                              TextWidget(
                                text: ' kcal',
                                fontSize: 14.sp,
                                // fontWeight: FontWeight.w700,
                                color: AppColors.txtColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              color: Color(0xff171626), // Dark background
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: LineChart(
                              LineChartData(
                                clipData: FlClipData.all(),
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                minY: -4.h,
                                //  maxX: 51.5.w,

                                maxY: 200.h,
                                lineBarsData: [
                                  // First line data
                                  LineChartBarData(
                                    spots: FitBitConst.heartRateSpots,
                                    // [
                                    //   // FlSpot(0, 2),
                                    //   // FlSpot(1, 1.8),
                                    //   // FlSpot(2, 2.8),
                                    //   // FlSpot(3, 2.5),
                                    //   // // FlSpot(3.6, 3),
                                    //   // // FlSpot(4, 3.5),
                                    //   // FlSpot(4.2, 4.5),
                                    //   // FlSpot(4.7, 3.8),
                                    // ],
                                    isCurved: true,
                                    color: Colors.cyanAccent,
                                    barWidth: 3,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        if (index == barData.spots.length - 1) {
                                          return FlDotCirclePainter(
                                            radius: 5,
                                            color: Colors.cyanAccent,
                                            strokeWidth: 2,
                                            strokeColor: Colors.black,
                                          );
                                        }
                                        return FlDotCirclePainter(radius: 0);
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  // Second line data
                                  LineChartBarData(
                                    spots: FitBitConst.activityLevelSpots,
                                    // [
                                    //   FlSpot(0, 1),
                                    //   FlSpot(1, 2.5),
                                    //   FlSpot(2, 1.5),
                                    //   FlSpot(3, 3.2),
                                    //   FlSpot(4, 2.3),
                                    //   FlSpot(5, 3.8),
                                    // ],
                                    isCurved: true,

                                    color: Colors.cyan.withOpacity(.5),
                                    barWidth: 3,
                                    dotData: FlDotData(
                                      show: true,
                                      // No dots for second line or customize as needed
                                      checkToShowDot: (spot, barData) => false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 300),
                        child: Center(
                          child: Text(
                            " No activity data available",
                            style: TextStyle(
                                fontSize: 13.sp, color: AppColors.txtColor),
                          ),
                        ),
                      ),
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

  Future<void> _pickDate(BuildContext context, String dateType) async {
    final controller = BottomBarController.to;
    final activitycontroller = Activitycontroller.to;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(activitycontroller.startDate.value),
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
          activitycontroller.startDate.value = formattedDate;
        } 
    
      // var n = await Future.wait([
      //   FitBitRepo().fetchFitbitCalories(
      //       startDate: pickedDate.subtract(Duration(days: 1)),
      //       endDate: pickedDate),
      //   FitBitRepo().fetchFitbitHeartRate(date: pickedDate),
      //   FitBitRepo().fetchFitbitSleep(date: pickedDate),
      //   FitBitRepo().fetchFitbitSteps(
      //       startDate: pickedDate.subtract(Duration(days: 1)),
      //       endDate: pickedDate),
      // ]);
      FitBitRepo().fetchtodayActivity(date: pickedDate);
controller.isLoading.value = false;
      // if (n.isNotEmpty) {
      //   controller.isLoading.value = false;
      // }
    }
  }
}
