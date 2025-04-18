import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/utils/custom_text_field.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:fitnessapp/src/features/profile_screen/controller/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?) validator;
  final String hintText;
  final bool isDobField;
  final bool isBmiField;
  final String? bmiValue;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.validator,
    required this.hintText,
    this.isDobField = false,
    this.isBmiField = false,
    this.bmiValue,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.cardbgColor,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextWidget(
                text: text,
                color: AppColors.txtColor,
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: isDobField && ProfileController.to.isEdit.value
                  ? () => _pickDate(context)
                  : null,
              child: AbsorbPointer(
                absorbing: isDobField || isBmiField,
                child: IgnorePointer(
                  ignoring: !ProfileController.to.isEdit.value || isBmiField,
                  child: CustomTextFormField(
                    enable: !isBmiField && ProfileController.to.isEdit.value,
                    validator: validator,
                    hint: hintText,
                    borderRadius: 12,
                    filledColor: AppColors.cardbgColor,
                    hintTextColor: Colors.grey,
                    controller: isBmiField
                        ? TextEditingController(text: bmiValue ?? 'N/A')
                        : controller,
                    borderColor: AppColors.cardbgColor,
                    focusedBorderColor: AppColors.cardbgColor,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
