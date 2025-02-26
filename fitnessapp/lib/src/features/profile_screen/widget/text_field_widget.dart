import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/custom_text_field.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?) validator;
  final String hintText;

  const ProfileTextField(
      {super.key,
      required this.controller,
      required this.text,
      required this.validator,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: TextWidget(
              text: text ?? '',
              color: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        CustomTextFormField(
          validator: validator,
          hint: hintText,
          borderRadius: 12,
          filledColor: AppColors.cardColor,
          hintTextColor: AppColors.whiteColor.withOpacity(.6),
          controller: controller,
          borderColor: AppColors.cardColor,
          focusedBorderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
