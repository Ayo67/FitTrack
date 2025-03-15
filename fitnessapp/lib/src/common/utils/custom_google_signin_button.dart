import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomSigInButton extends StatelessWidget {
  final String svgIconPath;
  final String text;
  final VoidCallback onPressed;

  const CustomSigInButton({
    Key? key,
    required this.svgIconPath,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.bgColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              svgIconPath,
              width: 23.h,
              height: 23.w,
            ),
            Expanded(
              child: Center(
                child: TextWidget(
                  text: text,
                  fontSize: 14.sp,
                  color: AppColors.whiteColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 23), // Placeholder to balance spacing
          ],
        ),
      ),
    );
  }
}
