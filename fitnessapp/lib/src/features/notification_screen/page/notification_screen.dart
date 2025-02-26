import 'package:FitTrack/src/common/constant/app_icons.dart';
import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:FitTrack/src/features/notification_screen/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
        title: TextWidget(
          text: 'Notifications',
          fontSize: 21.sp,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                    text: "Today's",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              NotificationTile(
                imagesvg: AppIcons.googleIcon,
                title: "30% Special Discount",
                subtitle: 'Special Discount valid today',
              ),
              SizedBox(
                height: 10,
              ),
              NotificationTile(
                imagesvg: AppIcons.lockIcon,
                title: "Password Updated",
                subtitle: 'Your password Updated successfuly',
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                    text: "Yesterday",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: NotificationTile(
                  imagesvg: AppIcons.emailIcon,
                  title: "Account Setup Successfully",
                  subtitle: 'Account has been set',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              NotificationTile(
                imagesvg: AppIcons.emailIcon,
                title: "Debit Card Added Successfully",
                subtitle: 'Card has been added successfully',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
