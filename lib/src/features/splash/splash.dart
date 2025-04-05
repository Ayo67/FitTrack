import 'dart:async';
import 'dart:developer';

import 'package:fitbitter/fitbitter.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/constant/sharedprefrence.dart';
import 'package:fitnessapp/src/features/activity_screen/controller/activitycontroller.dart';
import 'package:fitnessapp/src/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:fitnessapp/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:fitnessapp/src/repository/fitbit_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyCustomSplashScreen extends StatefulWidget {
  const MyCustomSplashScreen({super.key});

  @override
  _MyCustomSplashScreenState createState() => _MyCustomSplashScreenState();
}

class _MyCustomSplashScreenState extends State<MyCustomSplashScreen>
    with TickerProviderStateMixin {
  double _containerSize = 1.5;
  double _containerOpacity = 0.0;
  bool notificationinfo = false;
  AnimationController? _controller;
  Animation<double>? animation1;

  late final AnimationController _scaleController = AnimationController(
    duration: Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.fastOutSlowIn,
  );
  late Future<Widget> authScreen;
  Future<Widget> checkAuth() async {
    try {
      // Load stored Fitbit credentials
      FitBitConst.fitbitCredentials =
          await SharedPref().loadFitbitCredentials();

      if (FitBitConst.fitbitCredentials != null) {
        bool valid = await FitbitConnector.isTokenValid(
            fitbitCredentials: FitBitConst.fitbitCredentials!);

        if (valid) {
          final obj = FitBitRepo();
          // Fetch Fitbit data before navigating
          await Future.wait([
            obj.fetchFitbitCalories(),
            obj.fetchFitbitHeartRate(),
            obj.fetchFitbitSleep(),
            obj.fetchFitbitSteps(),
            obj.fetchFitbitProfile(),
            // obj.fetchFitbitSleepWeekly(),
            obj.fetchActivities(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                .format(DateTime.now().add(Duration(days: 1)))
                .toString())
          ]).then(
            (value) => FitBitRepo.events = value[5] as List,
          );
          obj.refreshtoken();

          return BottomBarScreen();
        } else {
          return SignInScreen();
        }
      } else {
        return SignInScreen();
      }
    } catch (e) {
      log("Auth Error: $e");
      return Scaffold(
        body: Center(child: Text("Auth Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Get.put(Activitycontroller());
    authScreen = checkAuth();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller!, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward();

    Timer(Duration(seconds: 2), () {
      setState(() {});
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });
    Future.delayed(Duration(seconds: 4), () {
      Get.offAll(
        () => FutureBuilder(
          future: authScreen,
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Scaffold(
                body: SizedBox(
                    width: 375.w,
                    height: 812.h,
                    child: Center(
                      child: SpinKitWave(
                        color: AppColors.primaryColor,
                        size: 100,
                      ),
                    ),
                  ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const Scaffold(
                body: Center(child: Text("Unexpected Error!")),
              );
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        child: Stack(
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  opacity: _containerOpacity,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: width / _containerSize,
                    width: width / _containerSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: Colors.amber,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/bg_removedlogo.png'),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}
