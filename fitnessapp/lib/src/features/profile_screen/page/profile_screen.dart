import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/custom_cotainer.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:FitTrack/src/common/validation.dart';
import 'package:FitTrack/src/features/notification_screen/page/notification_screen.dart';
import 'package:FitTrack/src/features/profile_screen/widget/profile_card_widget.dart';
import 'package:FitTrack/src/features/profile_screen/widget/text_field_widget.dart';
import 'package:FitTrack/src/repository/fitbit_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController heightCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Row(
              children: [
                TextWidget(
                  text: 'Good Morning',
                  fontSize: 17.sp,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w800,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(NotificationScreen());
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.cardColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.whiteColor,
                    size: 60.h,
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              TextWidget(
                text: 'Mark@mail.com',
                fontSize: 14.sp,
                color: AppColors.primaryColor,
              ),
              TextWidget(
                text: 'Mark',
                fontSize: 15.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomContainer(
                // width: 120.w,
                borderRadius: 8.r,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_square,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextWidget(
                      text: 'Edit Profile',
                      color: AppColors.black,
                      fontSize: 12.sp,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileCardWidget(
                      title: '1046',
                      subTitle: 'Steps',
                      iconWidget: Icon(
                        Icons.directions_run,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      )),
                  ProfileCardWidget(
                      title: '86',
                      subTitle: 'bmp',
                      iconWidget: Icon(
                        Icons.favorite,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      ))
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileCardWidget(
                      title: '3',
                      subTitle: 'Sessions',
                      iconWidget: Icon(
                        Icons.fitness_center,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      )),
                  ProfileCardWidget(
                      title: '400',
                      subTitle: 'kcal',
                      iconWidget: Icon(
                        Icons.local_fire_department,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      ))
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileCardWidget(
                      title: '400',
                      subTitle: 'kcal',
                      iconWidget: Icon(
                        Icons.local_fire_department,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      )),
                  SizedBox(
                    width: ScreenUtil().screenWidth / 2.3,
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: 'Personal Informations',
                  color: AppColors.whiteColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: nameCtrl,
                  text: 'Name',
                  validator: (val) => nameValidator(val),
                  hintText: 'Mark'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: ageCtrl,
                  text: 'Age',
                  validator: (val) => nameValidator(val),
                  hintText: '23 Year'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: genderCtrl,
                  text: 'Gender',
                  validator: (val) => nameValidator(val),
                  hintText: 'Male'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: heightCtrl,
                  text: 'Height',
                  validator: (val) => nameValidator(val),
                  hintText: '5 fit 6in'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: weightCtrl,
                  text: 'Weight',
                  validator: (val) => nameValidator(val),
                  hintText: '63Kg'),
              SizedBox(
                height: 50.h,
              ),
              CustomContainer(
                onTap: () {
                  // Get.off(SignInScreen());
                  FitBitRepo().fitBitAuth();
                },
                height: 60.h,
                width: double.infinity,
                borderRadius: 12.r,
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextWidget(
                      text: 'Authorize To FitBit',
                      fontSize: 14.sp,
                      color: AppColors.bgColor,
                      fontWeight: FontWeight.w600,
                    ),
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
}
