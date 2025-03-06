import 'dart:developer';

import 'package:fitbitter/fitbitter.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/constant/sharedprefrence.dart';
import 'package:fitnessapp/src/common/constant/strings.dart';
import 'package:fitnessapp/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:fitnessapp/src/repository/sleep_model.dart';
import 'package:get/get.dart';

class FitBitRepo {
  // Authorize the app and get the Fitbit credentials

  fitBitAuth() async {
    // Optional: customize the token lifetime in seconds. It can be 3600 (1 hour), 28800 (8 hours), 86400 (1 day), 604800 (1 week), 2592000 (30 days), or 31536000 (1 year)
    //           If this is not specified, by default it will be 28800.
    //           As an example, here we are requesting a lifetime of 2592000 seconds
    int expiresIn = 2592000;
    FitBitConst.fitbitCredentials = await FitbitConnector.authorize(
            clientID: Strings.fitbitClientID,
            clientSecret: Strings.fitbitClientSecret,
            redirectUri: Strings.fitbitRedirectUri,
            callbackUrlScheme: Strings.fitbitCallbackScheme,
            scopeList: FitBitConst.scopeList,
            expiresIn: expiresIn)
        .then((v) async {
      SharedPref().saveFitbitCredentials(v!);
      await FitBitRepo().fetchFitbitCalories();
      await FitBitRepo().fetchFitbitHeartRate();
      await FitBitRepo().fetchFitbitSleep();
      await FitBitRepo().fetchFitbitsteps();
      Get.off(BottomBarScreen());
      return v;
    });

    log("FitBit Auth-----  :   ${FitBitConst.fitbitCredentials.toString()}");
    // FitBitRepo().fetchFitbitHeartRate();
  }

  //// FETCH USER DATA FROM FITBIT

  Future<void> fetchFitbitProfile() async {
    try {
      FitbitAccountDataManager userDataManager = FitbitAccountDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );
      final List<FitbitData> uerData = await userDataManager
          .fetch(FitbitAccountAPIURL.withCredentials(
              fitbitCredentials: FitBitConst.fitbitCredentials!))
          .then(
        (value) {
          return value;
        },
      );
      FitBitConst.usesr = uerData[0] as FitbitAccountData;
      log("------- user data ---------- :${FitBitConst.usesr!.toJson()} ");
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }
  // herat rate

  Future<void> fetchFitbitHeartRate() async {
    try {
      FitbitHeartDataManager heartDataManager = FitbitHeartDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );
      final List<FitbitData> heartData = await heartDataManager
          .fetch(FitbitHeartRateIntradayAPIURL.dayAndDetailLevel(
              date: DateTime.now().subtract(Duration(days: 1)),
              intradayDetailLevel: IntradayDetailLevel.ONE_MINUTE,
              fitbitCredentials: FitBitConst.fitbitCredentials!))
          .then(
        (value) {
          return value;
        },
      );
      FitBitConst.heartRateData = heartData[0] as FitbitHeartRateData;
      log("------- Heart Data ---------- :${FitBitConst.heartRateData!.toJson()} ");
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> fetchFitbitSleep() async {
    try {
      FitbitSleepDataManager sleepDataManager = FitbitSleepDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );
      final SleepResponse sleepData = await sleepDataManager
          .getResponse(FitbitSleepAPIURL.day(
              date: DateTime.now().subtract(Duration(days: 1)),
              fitbitCredentials: FitBitConst.fitbitCredentials!))
          .then(
        (value) {
          return SleepResponse.fromJson(value);
        },
      );
      FitBitConst.sleepData = sleepData;
      log("------- sleep Data ---------- :${FitBitConst.sleepData!.summary.totalMinutesAsleep.toString()}");
    } catch (e) {
      print("Error fetching sleep: $e");
    }
  }
  // steps

  Future<void> fetchFitbitsteps() async {
    try {
      final FitbitActivityTimeseriesDataManager stepsDataManager =
          FitbitActivityTimeseriesDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final saleepData = await stepsDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
          startDate: DateTime.now().subtract(Duration(days: 1)), // Yesterday
          endDate: DateTime.now(),
          resource: Resource.steps,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );
      FitBitConst.stepsdataList =
          saleepData as List<FitbitActivityTimeseriesData>;
      log("------- steps Data ---------- :${FitBitConst.stepsdataList.toString()} ");
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }
  // kcal

  Future<void> fetchFitbitCalories() async {
    try {
      final FitbitActivityTimeseriesDataManager caloriesDataManager =
          FitbitActivityTimeseriesDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final saleepData = await caloriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
          startDate: DateTime.now().subtract(Duration(days: 1)), // Yesterday
          endDate: DateTime.now(),
          resource: Resource.calories,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );
      FitBitConst.caloriesdataList =
          saleepData as List<FitbitActivityTimeseriesData>;
      log("------- calories Data ---------- :${FitBitConst.caloriesdataList.toString()} ");
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }
}
