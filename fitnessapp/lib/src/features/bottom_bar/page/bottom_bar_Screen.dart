import 'package:FitTrack/src/common/constant/app_image.dart';
import 'package:FitTrack/src/common/constant/colors.dart';
import 'package:FitTrack/src/common/utils/custom_cotainer.dart';
import 'package:FitTrack/src/common/utils/text_widget.dart';
import 'package:FitTrack/src/features/activity_screen/page/activity_page.dart';
import 'package:FitTrack/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:FitTrack/src/features/home/screen/home_screen.dart';
import 'package:FitTrack/src/features/profile_screen/page/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomBarScreen extends StatelessWidget {
  BottomBarScreen({super.key});

  @override
  List<String> activeImage = [
    AppImage.activeHome,
    AppImage.lineBottonBarImage,
    AppImage.activeProfileImage
  ];
  List<String> inActiveImage = [
    AppImage.homeImage,
    AppImage.lineBottonBarImage,
    AppImage.profileImage
  ];
  List<String> textList = ['Home', 'Activity', 'Profile'];
  List<Widget> pages = [HomeScreen(), ActivityScreen(), ProfileScreen()];
  Widget build(BuildContext context) {
    Widget bottommBarButton(index) {
      bool isSelected = BottomBarController.to.bottomBarIndex.value == index;

      return GestureDetector(
          onTap: () {
            BottomBarController.to.updateBottomBarIndex(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? activeImage[index] : inActiveImage[index],
                height: 22.h,
                fit: BoxFit.cover,
                color:
                    isSelected ? AppColors.primaryColor : AppColors.whiteColor,
              ),
              SizedBox(
                height: 5.h,
              ),
              TextWidget(
                text: textList[index],
                color:
                    isSelected ? AppColors.primaryColor : AppColors.whiteColor,
                fontSize: 12.sp,
              )
            ],
          ));
    }

    return Scaffold(
      bottomNavigationBar: CustomContainer(
        height: 70.h,
        color: AppColors.cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: Obx(() {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bottommBarButton(0),
                  bottommBarButton(1),
                  bottommBarButton(2),
                ]);
          }),
        ),
      ),
      body: Obx(() => pages[BottomBarController.to.bottomBarIndex.value]),
    );
  }
}
