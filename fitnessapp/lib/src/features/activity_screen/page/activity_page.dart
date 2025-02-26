import 'dart:developer';

import 'package:FitTrack/src/common/constant/app_image.dart';
import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/custom_cotainer.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:FitTrack/src/features/notification_screen/page/notification_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  String? startDate;
  String? endDate;

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
                    Icons.calendar_month,
                    color: AppColors.primaryColor,
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
                      text: 'Monday',
                      fontSize: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                    TextWidget(
                      text: startDate != null ? '${startDate}' : '2025-02-03',
                      fontSize: 14.sp,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
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
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Walk',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomContainer(
                    onTap: () {
                      _pickDate(context, 'start');
                      log('---');
                    },
                    borderRadius: 8.r,
                    color: AppColors.cardColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: AppColors.whiteColor,
                          size: 20.h,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.whiteColor,
                          size: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        TextWidget(
                          text:
                              startDate != null ? '${startDate}' : '2025-02-03',
                          fontSize: 12.sp,
                          color: AppColors.whiteColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 280.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Image.asset(
                    AppImage.mapImages,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Steps Count :',
                      style: TextStyle(
                          fontSize: 13.sp, color: AppColors.whiteColor)),
                  TextSpan(
                      text: '   1049',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700))
                ])),
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
                  TextWidget(
                    text: '1h 30 min',
                    fontSize: 13.sp,
                  ),
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
                  TextWidget(
                    text: '400',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                  TextWidget(
                    text: ' kcal',
                    fontSize: 14.sp,
                    // fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
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
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minY: 0,
                          maxY: 5,
                          lineBarsData: [
                            // First line data
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 2),
                                FlSpot(1, 1.8),
                                FlSpot(2, 2.8),
                                FlSpot(3, 2.5),
                                // FlSpot(3.6, 3),
                                // FlSpot(4, 3.5),
                                FlSpot(4.2, 4.5),
                                FlSpot(4.7, 3.8),
                              ],
                              isCurved: true,
                              color: Colors.cyanAccent,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
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
                                color: AppColors.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            // Second line data
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 1),
                                FlSpot(1, 2.5),
                                FlSpot(2, 1.5),
                                FlSpot(3, 3.2),
                                FlSpot(4, 2.3),
                                FlSpot(5, 3.8),
                              ],
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
                                color: AppColors.primaryColor.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 18.h),
                      child: Text(
                        'Average 800 steps',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       '6:40',
                    //       style: TextStyle(color: Colors.white, fontSize: 12),
                    //     ),
                    //     SizedBox(width: 5),
                    //     Icon(Icons.circle, color: Colors.cyanAccent, size: 6),
                    //   ],
                    // ),
                    // SizedBox(height: 10),
                  ],
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
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set the minimum date
      lastDate: DateTime(2100), // Set the maximum date
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        if (dateType == 'start') {
          startDate = formattedDate;
        } else if (dateType == 'end') {
          endDate = formattedDate;
        }
      });
    }
  }
}
