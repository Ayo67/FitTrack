import 'package:FitTrack/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:FitTrack/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:FitTrack/src/features/activity_screen/page/activity_page.dart';
import 'package:FitTrack/src/features/auth/controller/auth_controller.dart';
import 'package:FitTrack/src/features/auth/forgot_password/forgot_password.dart';
import 'package:FitTrack/src/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:FitTrack/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:FitTrack/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:FitTrack/src/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return SafeArea(
            child: GetMaterialApp(
              onInit: () {
                Get.put(AuthController());
                Get.put(BottomBarController());
              },
              debugShowCheckedModeBanner: false,
              home: SignInScreen(),
            ),
          );
        });
  }
}
