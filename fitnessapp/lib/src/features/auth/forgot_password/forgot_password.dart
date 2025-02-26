import 'dart:developer';

import 'package:fitnessapp/src/common/constant/app_icons.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/custom_text_field.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/common/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  TextEditingController emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      ),
      backgroundColor: AppColors.bgColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.h,
              ),
              TextWidget(
                text: 'Forgot Password?',
                fontSize: 22.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: TextWidget(
                  text:
                      'Please enter an email address that you used to create account with so we can send you an email to reset your password.',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomTextFormField(
                validator: (value) => emailValidator(value),
                hint: 'Email',
                borderRadius: 12,
                filledColor: AppColors.bgColor,
                hintTextColor: AppColors.whiteColor.withOpacity(.6),
                controller: emailCtrl,
                borderColor: AppColors.whiteColor.withOpacity(.4),
                focusedBorderColor: AppColors.primaryColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    AppIcons.emailIcon,
                    color: AppColors.whiteColor.withOpacity(.7),
                    height: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomContainer(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Get.snackbar(
                        colorText: AppColors.whiteColor,
                        'Forgot password',
                        'We send a forgot password link to you gmail\n please check!.');
                    log('-------validation complete');
                  }
                },
                height: 60.h,
                width: double.infinity,
                borderRadius: 12.r,
                color: AppColors.primaryColor,
                child: Center(
                  child: TextWidget(
                    text: 'Send Email',
                    fontSize: 14.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
