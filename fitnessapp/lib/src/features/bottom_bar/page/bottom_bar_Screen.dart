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
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final controller = BottomBarController.to;

  @override
  Widget build(BuildContext context) {
    Widget bottommBarButton(index) {
      bool isSelected = BottomBarController.to.bottomBarIndex.value == index;

      return GestureDetector(
          onTap: () {
            if (controller.isLoading.value == false) {
              BottomBarController.to.updateBottomBarIndex(index);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? activeImage[index] : inActiveImage[index],
                height: 22.h,
                fit: BoxFit.cover,
                color: isSelected ? AppColors.btnColor : AppColors.txtColor,
              ),
              SizedBox(
                height: 5.h,
              ),
              TextWidget(
                text: textList[index],
                color: isSelected ? AppColors.btnColor : AppColors.txtColor,
                fontSize: 12.sp,
              )
            ],
          ));
    }

    return Scaffold(
      bottomNavigationBar: CustomContainer(
        height: 70.h,
        color: AppColors.cardbgColor,
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
      body: Stack(
        children: [
          Obx(() => pages[BottomBarController.to.bottomBarIndex.value]),
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.grey.withOpacity(0.3),
                    width: 375.w,
                    height: 812.h,
                    child: Center(
                      child: SpinKitWave(
                        color: AppColors.primaryColor,
                        size: 100,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
