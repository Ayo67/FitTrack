import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/utils/text_widget.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String imagesvg;
  final String title;
  final String subtitle;

  const NotificationTile({
    required this.imagesvg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 86,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.notification_important_outlined),
                ],
              ),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                    text: title,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600),
                TextWidget(
                    text: subtitle,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
