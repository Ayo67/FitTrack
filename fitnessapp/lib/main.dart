// import 'package:firebase_core/firebase_core.dart'; 
import 'package:FitTrack/src/common/constant/fitbitconst.dart';
import 'package:FitTrack/src/common/constant/sharedprefrence.dart';
import 'package:FitTrack/src/features/auth/controller/auth_controller.dart';
import 'package:FitTrack/src/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:FitTrack/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:FitTrack/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:FitTrack/src/repository/fitbit_repo.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              // home: BottomBarScreen(),
              home: FutureBuilder(
                future: checkAuth(),
                builder: (context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return Center(
                      child: Text("wellcome"),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  Future<Widget> checkAuth() async {
    FitBitConst.fitbitCredentials = await SharedPref().loadFitbitCredentials();
    if (FitBitConst.fitbitCredentials != null) {
      bool valid = await FitbitConnector.isTokenValid(
          fitbitCredentials: FitBitConst.fitbitCredentials!);
      if (valid) {
        await FitBitRepo().fetchFitbitCalories();
        await FitBitRepo().fetchFitbitHeartRate();
        await FitBitRepo().fetchFitbitSleep();
        await FitBitRepo().fetchFitbitsteps();

        return BottomBarScreen();
      } else {
        return SignInScreen();
      }
    } else {
      return SignInScreen();
    }
  }
}
