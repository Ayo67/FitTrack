import 'dart:developer';

import 'package:fitnessapp/src/common/constant/app_icons.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/utils/custom_cotainer.dart';
import 'package:fitnessapp/src/common/utils/custom_google_signin_button.dart';
import 'package:fitnessapp/src/common/utils/custom_text_field.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/common/validation.dart';
import 'package:fitnessapp/src/features/auth/controller/auth_controller.dart';
import 'package:fitnessapp/src/features/auth/forgot_password/forgot_password.dart';
import 'package:fitnessapp/src/features/auth/sign_up_screen/sign_up_screen.dart';
import 'package:fitnessapp/src/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final email = TextEditingController();

  final password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60.h,
              ),
              TextWidget(
                  text: "Let's Sign In",
                  color: AppColors.whiteColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: 'Fill the information to login account!',
                  color: AppColors.whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700),
              SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                validator: (value) => emailValidator(value),
                hint: 'Email',
                borderRadius: 12,
                filledColor: AppColors.bgColor,
                hintTextColor: AppColors.whiteColor.withOpacity(.6),
                controller: email,
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
                height: 20,
              ),
              Obx(() {
                return CustomTextFormField(
                  validator: (value) => passwordValidator(value),
                  hint: 'Enter Password',
                  borderRadius: 12,
                  filledColor: AppColors.bgColor,
                  hintTextColor: AppColors.whiteColor.withOpacity(.6),
                  controller: password,
                  borderColor: AppColors.whiteColor.withOpacity(.4),
                  focusedBorderColor: AppColors.primaryColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      AppIcons.lockIcon,
                      color: AppColors.whiteColor.withOpacity(.7),
                      height: 15,
                    ),
                  ),
                  obsecure: AuthController.to.visibilityBool.value,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        AuthController.to.changeVisibilityStatus();
                      },
                      child: AuthController.to.visibilityBool.value
                          ? Icon(
                              Icons.visibility_off,
                              color: AppColors.whiteColor.withOpacity(.6),
                            )
                          : Icon(
                              Icons.visibility,
                              color: AppColors.whiteColor.withOpacity(.6),
                            )),
                );
              }),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthController.to.changeRemeberMeStatus();
                        },
                        child: Obx(() {
                          return Container(
                            height: 19.h,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: AuthController.to.rememberMe.value
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                            child: AuthController.to.rememberMe.value
                                ? const Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.white,
                                  )
                                : null,
                          );
                        }),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      TextWidget(
                        text: 'Remember me',
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(ForgotPasswordScreen());
                    },
                    child: TextWidget(
                      text: 'Forgot Passowrd?',
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomContainer(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Get.to(HomeScreen());
                    log('-------validation complete');
                  }
                },
                height: 60.h,
                width: double.infinity,
                borderRadius: 12.r,
                color: AppColors.primaryColor,
                child: Center(
                  child: TextWidget(
                    text: 'Log In',
                    fontSize: 14.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: TextWidget(
                  text: 'Or Continue with',
                  color: AppColors.whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              CustomSigInButton(
                  svgIconPath: AppIcons.googleIcon,
                  text: 'Continue With Google',
                  onPressed: () {}),
              SizedBox(
                height: 140.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(SignUpScreen());
                },
                child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Don't have an account?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    TextSpan(
                      text: ' Sign Up',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    )
                  ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
