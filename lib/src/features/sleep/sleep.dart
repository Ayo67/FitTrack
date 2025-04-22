import 'dart:developer';

import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/repository/sleep_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SleepTrackerScreen extends StatelessWidget {
  const SleepTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(375, 812)); // iPhone 13 size
    final sleepData = FitBitConst.sleepData!.sleep.isNotEmpty
        ? FitBitConst.sleepData!.sleep.first
        : null;

    // final progress = sleepData.minutesAsleep / (8 * 60);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 24.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Sleep',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: sleepData == null
          ? Center(
              child: Text(
                'No sleep data available',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Today's sleep
                  Text(
                    _formatDate(sleepData.dateOfSleep),
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),

                  // Sleep duration progress
                  Container(
                    padding: EdgeInsets.all(16.w),
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${sleepData.minutesAsleep ~/ 60}h ${sleepData.minutesAsleep % 60}m of 8h goal',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _getEfficiencyColor(sleepData.efficiency)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                sleepData.efficiency.toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _getEfficiencyColor(sleepData.efficiency),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _getSleepQuality(sleepData.efficiency),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _getEfficiencyColor(sleepData.efficiency),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Sleep timeline header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sleep timeline',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Sleep time range
                  Container(
                    width: ScreenUtil().screenWidth,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_formatTime(DateTime.parse(sleepData.endTime).subtract(Duration(minutes: sleepData.timeInBed)))} - ${_formatTime(DateTime.parse(sleepData.endTime))}',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          sleepData.isMainSleep ? 'Main sleep' : 'Nap',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Sleep stages chart
                  SizedBox(
                      height: 200.h,
                      width: ScreenUtil().screenWidth,
                      child: HypnogramWidget())
                ],
              ),
            ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12;
    final period = time.hour < 12 ? 'a.m.' : 'p.m.';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${_weekday(date.weekday)}, ${date.month}/${date.day}/${date.year}';
  }

  String _getSleepQuality(int efficiency) {
    if (efficiency >= 85) return 'Excellent';
    if (efficiency >= 70) return 'Good';
    if (efficiency >= 50) return 'Fair';
    return 'Poor';
  }

  Color _getEfficiencyColor(int efficiency) {
    if (efficiency >= 85) return Colors.green;
    if (efficiency >= 70) return Colors.blue;
    if (efficiency >= 50) return Colors.orange;
    return Colors.red;
  }

  String _weekday(int day) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return weekdays[day % 7];
  }
}

class HypnogramWidget extends StatelessWidget {
  const HypnogramWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log("sleep levels ${FitBitConst.sleepstagesegment}");
    final segments = FitBitConst.sleepstagesegment;

    //     [
    //   SleepStageSegment(stage: "Awake", startMinute: 0, durationMinutes: 20),
    //   SleepStageSegment(stage: "Light", startMinute: 20, durationMinutes: 45),
    //   SleepStageSegment(stage: "Deep", startMinute: 65, durationMinutes: 30),
    //   SleepStageSegment(stage: "REM", startMinute: 95, durationMinutes: 25),
    //   SleepStageSegment(stage: "Light", startMinute: 120, durationMinutes: 60),
    //   SleepStageSegment(stage: "REM", startMinute: 180, durationMinutes: 20),
    //   SleepStageSegment(stage: "Awake", startMinute: 200, durationMinutes: 5),
    //   SleepStageSegment(stage: "Light", startMinute: 205, durationMinutes: 40),
    //   SleepStageSegment(stage: "REM", startMinute: 245, durationMinutes: 18),
    //   SleepStageSegment(stage: "Awake", startMinute: 263, durationMinutes: 5),
    //   SleepStageSegment(stage: "Light", startMinute: 268, durationMinutes: 25),
    //   SleepStageSegment(stage: "REM", startMinute: 293, durationMinutes: 20),
    //   SleepStageSegment(stage: "Awake", startMinute: 313, durationMinutes: 5),
    // ];
    return LayoutBuilder(
      builder: (context, constraints) {
        return segments == null || segments.isEmpty
            ? Center(
                child: Text('No sleep levels found',
                    style: TextStyle(fontSize: 16.sp)))
            : CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: HypnogramPainter(segments),
              );
      },
    );
  }
}

class HypnogramPainter extends CustomPainter {
  final List<SleepStageSegment> segments;
  final Map<String, double> stageY = {
    'Awake': 0,
    'REM': 1,
    'Light': 2,
    'Deep': 3,
  };

  final Map<String, Color> stageColor = {
    'Awake': const Color(0xFFF9A825),
    'REM': const Color(0xFF7B1FA2),
    'Light': const Color(0xFF9575CD),
    'Deep': const Color(0xFF512DA8),
  };

  HypnogramPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const stageHeight = 20.0;
    const spacing = 50.0;
    final totalMinutes = segments
        .map((e) => e.startMinute + e.durationMinutes)
        .reduce((a, b) => a > b ? a : b);
    const labelStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87);
    final hourMarks = (totalMinutes / 60).ceil();

    // Draw horizontal stage labels and dotted lines
    stageY.forEach((stage, pos) {
      final y = pos * spacing;

      final textPainter = TextPainter(
        text: TextSpan(text: stage, style: labelStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y));

      final dottedPaint = Paint()
        ..color = Colors.grey.shade300
        ..strokeWidth = 1;

      const dashWidth = 5;
      const dashSpace = 3;
      double startX = 60;
      final yLine = y + stageHeight / 2;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, yLine),
          Offset(startX + dashWidth, yLine),
          dottedPaint,
        );
        startX += dashWidth + dashSpace;
      }
    });

    // Draw vertical hour time labels
    for (int i = 0; i <= hourMarks; i++) {
      final x = 60 + (i * 60 / totalMinutes) * (size.width - 60);
      final timeLabel = '${i}h';

      final textPainter = TextPainter(
        text: TextSpan(
            text: timeLabel,
            style: const TextStyle(fontSize: 12, color: Colors.black87)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, size.height - 20));
    }

    // Draw bars and connectors
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final xStart =
          60 + (segment.startMinute / totalMinutes) * (size.width - 60);
      final xEnd = 60 +
          ((segment.startMinute + segment.durationMinutes) / totalMinutes) *
              (size.width - 60);
      final y = (stageY[segment.stage] ?? 0) * spacing;

      paint.color = stageColor[segment.stage] ?? Colors.grey;
      canvas.drawRect(Rect.fromLTRB(xStart, y, xEnd, y + stageHeight), paint);

      // Connector to next segment
      if (i < segments.length - 1) {
        final next = segments[i + 1];
        final nextY = (stageY[next.stage] ?? 0) * spacing + stageHeight / 2;
        final connectorPaint = Paint()
          ..color = Colors.grey
          ..strokeWidth = 1;

        const dashHeight = 4;
        const dashGap = 3;
        double yStart = y + stageHeight / 2;
        while ((nextY - yStart).abs() > dashGap) {
          canvas.drawLine(
            Offset(xEnd, yStart),
            Offset(xEnd, yStart + (nextY > yStart ? dashHeight : -dashHeight)),
            connectorPaint,
          );
          yStart +=
              (nextY > yStart ? dashHeight + dashGap : -dashHeight - dashGap);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
