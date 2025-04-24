import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/constant/sharedprefrence.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/common/validation.dart';
import 'package:fitnessapp/src/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:fitnessapp/src/features/profile_screen/controller/profilecontroller.dart';
import 'package:fitnessapp/src/features/profile_screen/widget/profile_card_widget.dart';
import 'package:fitnessapp/src/features/profile_screen/widget/text_field_widget.dart';
import 'package:fitnessapp/src/repository/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  TextEditingController nameCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.fullName.toString(),
  );
  TextEditingController ageCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.age.toString(),
  );
  TextEditingController genderCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.gender.toString(),
  );
  TextEditingController heightCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.height.toString(),
  );
  TextEditingController weightCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.weight.toString(),
  );
  TextEditingController emailCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.email.toString(),
  );
  TextEditingController usernameCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.userName.toString(),
  );
  TextEditingController phoneCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.phoneNo.toString(),
  );
  TextEditingController fatCtrl = TextEditingController(
    text: FitBitConst.usesrData.value.bodyFat.toString(),
  );
  TextEditingController dobCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(
    FitBitConst.usesrData.value.dateOfBirth!,
  ));

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
                  color: AppColors.txtColor,
                  fontWeight: FontWeight.w800,
                ),
                Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(NotificationScreen());
                //   },
                //   child: Container(
                //     height: 40.h,
                //     width: 40.w,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.primaryColor,
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
              // TextWidget(
              //   text: 'Mark@mail.com',
              //   fontSize: 14.sp,
              //   color: AppColors.primaryColor,
              // ),
              TextWidget(
                text: FitBitConst.usesrData.value.fullName.toString(),
                fontSize: 15.sp,
                color: AppColors.txtColor,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: 10.h,
              ),
              // CustomContainer(
              //   // width: 120.w,
              //   borderRadius: 8.r,
              //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              //   color: AppColors.primaryColor,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         Icons.edit_square,
              //       ),
              //       SizedBox(
              //         width: 10.w,
              //       ),
              //       TextWidget(
              //         text: 'Edit Profile',
              //         color: AppColors.black,
              //         fontSize: 12.sp,
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileCardWidget(
                      title: FitBitConst.stepsdataList![0].value!
                          .toInt()
                          .toString(),
                      subTitle: 'Steps',
                      iconWidget: Icon(
                        Icons.directions_run,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      )),
                  ProfileCardWidget(
                      title: (FitBitConst.heartRateData!.restingHeartRate ?? 0)
                          .toString(),
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
                      title:
                          (FitBitConst.todayActivities!.length ?? 0).toString(),
                      subTitle: 'Sessions',
                      iconWidget: Icon(
                        Icons.fitness_center,
                        color: AppColors.primaryColor.withOpacity(.6),
                        size: 35.h,
                      )),
                  ProfileCardWidget(
                      title: FitBitConst.caloriesdataList![0].value!
                          .toInt()
                          .toString(),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ProfileCardWidget(
              //         title: '400',
              //         subTitle: 'kcal',
              //         iconWidget: Icon(
              //           Icons.local_fire_department,
              //           color: AppColors.primaryColor.withOpacity(.6),
              //           size: 35.h,
              //         )),
              //     SizedBox(
              //       width: ScreenUtil().screenWidth / 2.3,
              //     )
              //   ],
              // ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: 'Personal Information',
                  color: AppColors.txtColor,
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
                  controller: emailCtrl,
                  text: 'Email',
                  validator: (val) => emailValidator(val),
                  hintText: 'Mark@abc.abc'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: usernameCtrl,
                  text: 'Username',
                  validator: (val) => validator(val),
                  hintText: 'Mark.12'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: phoneCtrl,
                  text: 'Phone No',
                  validator: (val) => validatePhoneNumber(val!),
                  hintText: '123456789'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: ageCtrl,
                  text: 'Age',
                  validator: (val) => validator(val),
                  hintText: '23'),
              SizedBox(
                height: 10.h,
              ),

              ProfileTextField(
                controller: dobCtrl,
                text: "Date of Birth",
                hintText: "Select your date of birth",
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return "Please select your DOB";
                  return null;
                },
                isDobField: true,
              ),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: genderCtrl,
                  text: 'Gender',
                  validator: (val) => validator(val),
                  hintText: 'Male'),
              SizedBox(
                height: 10.h,
              ),
              ProfileTextField(
                  controller: heightCtrl,
                  text: 'Height',
                  validator: (val) => validator(val),
                  hintText: '300'),
              SizedBox(
                height: 10.h,
              ),

              ProfileTextField(
                  controller: weightCtrl,
                  text: 'Weight',
                  validator: (val) => validator(val),
                  hintText: '63.45'),

              SizedBox(
                height: 10.h,
              ),

              ProfileTextField(
                  controller: fatCtrl,
                  text: 'Body Fat',
                  validator: (val) => validator(val),
                  hintText: '63.45'),

              SizedBox(
                height: 10.h,
              ),
              Obx(
              () {
                  return ProfileTextField(
                    controller: TextEditingController(),
                    text: 'BMI',
                    hintText: "",
                    validator: (val) => null,
                    isBmiField: true,
                    bmiValue: ProfileController.to.getBmiWithCategory(
                      FitBitConst.usesrData.value.weight ?? 0,
                      FitBitConst.usesrData.value.height ?? 1,
                    ),
                  );
                }
              ),

              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return CustomContainer(
                      onTap: () {
                        if (ProfileController.to.isEdit.value) {
                          nameCtrl.text =
                              FitBitConst.usesrData.value.fullName ?? "";
                          ageCtrl.text =
                              FitBitConst.usesrData.value.age?.toString() ?? "";
                          genderCtrl.text =
                              FitBitConst.usesrData.value.gender ?? "";
                          heightCtrl.text =
                              FitBitConst.usesrData.value.height?.toString() ??
                                  "";
                          weightCtrl.text =
                              FitBitConst.usesrData.value.weight?.toString() ??
                                  "";
                          emailCtrl.text =
                              FitBitConst.usesrData.value.email ?? "";
                          usernameCtrl.text =
                              FitBitConst.usesrData.value.userName ?? "";
                          phoneCtrl.text =
                              FitBitConst.usesrData.value.phoneNo ?? "";
                          fatCtrl.text =
                              FitBitConst.usesrData.value.bodyFat?.toString() ??
                                  "";
                          dobCtrl.text =
                              FitBitConst.usesrData.value.dateOfBirth != null
                                  ? DateFormat('yyyy-MM-dd').format(
                                      FitBitConst.usesrData.value.dateOfBirth!)
                                  : "";
                          ProfileController.to.isEdit.value = false;
                        } else {
                          Get.off(SignInScreen());
                          SharedPref().deleteFitbitCredentials();
                        }
                      },
                      height: 60.h,
                      width: 150.w,
                      borderRadius: 12.r,
                      color: ProfileController.to.isEdit.value
                          ? Colors.red
                          : AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ProfileController.to.isEdit.value
                                ? Icons.close_outlined
                                : Icons.logout,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          TextWidget(
                            text: ProfileController.to.isEdit.value
                                ? "Cancel"
                                : 'Log Out',
                            fontSize: 14.sp,
                            color: AppColors.bgColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() => CustomContainer(
                        onTap: () {
                          if (!ProfileController.to.isEdit.value) {
                            ProfileController.to.isEdit.toggle();
                          } else {
                            UserModel updatedUser = UserModel(
                              age: int.tryParse(ageCtrl.text),
                              userID: FitBitConst.usesrData.value.userID,
                              weight: double.tryParse(weightCtrl.text),
                              height: double.tryParse(heightCtrl.text),
                              bodyFat: double.tryParse(fatCtrl.text),
                              fullName: nameCtrl.text,
                              userName: usernameCtrl.text,
                              phoneNo: phoneCtrl.text,
                              email: emailCtrl.text,
                              gender: genderCtrl.text,
                              dateOfBirth: dobCtrl.text.isNotEmpty
                                  ? DateTime.tryParse(dobCtrl.text)
                                  : FitBitConst.usesrData.value.dateOfBirth,
                            );

                            ProfileController.to.edit(updatedUser);
                          }
                        },
                        height: 60.h,
                        width: 150.w,
                        borderRadius: 12.r,
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              ProfileController.to.isEdit.value
                                  ? Icons.done
                                  : Icons.edit,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            TextWidget(
                              text: ProfileController.to.isEdit.value
                                  ? 'Done'
                                  : 'Edit',
                              fontSize: 14.sp,
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ))
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
}
