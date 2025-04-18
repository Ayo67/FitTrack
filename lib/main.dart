import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/src/features/auth/controller/auth_controller.dart';
import 'package:fitnessapp/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:fitnessapp/src/features/home/controller/homecontroller.dart';
import 'package:fitnessapp/src/features/profile_screen/controller/profilecontroller.dart';
import 'package:fitnessapp/src/features/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
              Get.put(Homecontroller());
              Get.put(ProfileController());
            },
            debugShowCheckedModeBanner: false,
             home: MyCustomSplashScreen(),
          ),
        );
      },
    );
  }
}
