import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:fitnessapp/src/common/constant/colors.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/common/constant/sharedprefrence.dart';
import 'package:fitnessapp/src/common/constant/strings.dart';
import 'package:fitnessapp/src/common/utils/formate_dates.dart';
import 'package:fitnessapp/src/features/activity_screen/controller/activitycontroller.dart';
import 'package:fitnessapp/src/features/auth/controller/auth_controller.dart';
import 'package:fitnessapp/src/features/auth/sign_in_screen/sign_in_screen.dart';
import 'package:fitnessapp/src/features/bottom_bar/page/bottom_bar_Screen.dart';
import 'package:fitnessapp/src/features/home/controller/homecontroller.dart';
import 'package:fitnessapp/src/repository/avg_heartrate_model.dart';
import 'package:fitnessapp/src/repository/sleep_model.dart';
import 'package:fitnessapp/src/repository/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

class FitBitRepo {
  static List<dynamic>? events;
  // Authorize the app and get the Fitbit credentials
  Future<void> fitBitAuth() async {
    try {
      FitBitConst.fitbitCredentials = await FitbitConnector.authorize(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
        redirectUri: Strings.fitbitRedirectUri,
        callbackUrlScheme: Strings.fitbitCallbackScheme,
        scopeList: FitBitConst.scopeList,
        expiresIn: 2592000, // Token expires in 30 days
      );

      if (FitBitConst.fitbitCredentials != null) {
        AuthController.to.isloading.value = true;
        // Fetch all Fitbit data in parallel
        await Future.wait([
          fetchFitbitCalories()
              .catchError((e) => log("Error fetching calories: $e")),
          fetchFitbitHeartRate()
              .catchError((e) => log("Error fetching heart rate: $e")),
          fetchFitbitSleep().catchError((e) => log("Error fetching sleep: $e")),
          fetchFitbitSteps().catchError((e) => log("Error fetching steps: $e")),
          fetchFitbitProfile()
              .catchError((e) => log("Error fetching profile: $e")),
          fetchActivities(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
              .format(DateTime.now().add(Duration(days: 1)))
              .toString()),
        ]).then(
          (value) => events = value[5] as List,
        );
        AuthController.to.isloading.value = false;

        refreshtoken();

        Get.off(BottomBarScreen());
      } else {
        log("Fitbit authorization failed.");
        unauthorize();
      }
    } catch (e, stackTrace) {
      log("Error during Fitbit authentication: $e");
      unauthorize();

      log(stackTrace.toString());
    }
  }

//refresh token
  refreshtoken() async {
    bool valid = await FitbitConnector.isTokenValid(
        fitbitCredentials: FitBitConst.fitbitCredentials!);
    if (!valid) {
      FitBitConst.fitbitCredentials = await FitbitConnector.refreshToken(
          clientID: Strings.fitbitClientID,
          clientSecret: Strings.fitbitClientSecret,
          fitbitCredentials: FitBitConst.fitbitCredentials!);
    }
    await SharedPref().saveFitbitCredentials(FitBitConst.fitbitCredentials!);
  }

//unauthorize
  unauthorize() async {
    await FitbitConnector.unauthorize(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
        fitbitCredentials: FitBitConst.fitbitCredentials!);
    Get.off(SignInScreen());
    SharedPref().deleteFitbitCredentials();
  }

  /// **Fetch User Profile**
  Future<void> fetchFitbitProfile() async {
    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null. Please authorize first.");
        unauthorize();
        return;
      }
      final inst = FirebaseFirestore.instance;
      final userdata = await inst
          .collection("users")
          .where("userID", isEqualTo: FitBitConst.fitbitCredentials!.userID)
          .get()
          .then(
        (value) {
          return value;
        },
      );
      if (userdata.docs.isEmpty) {
        FitbitAccountDataManager userDataManager = FitbitAccountDataManager(
          clientID: Strings.fitbitClientID,
          clientSecret: Strings.fitbitClientSecret,
        );

        final List<FitbitData> userData = await userDataManager.fetch(
          FitbitAccountAPIURL.withCredentials(
              fitbitCredentials: FitBitConst.fitbitCredentials!),
        );

        if (userData.isEmpty) {
          log("Error: No user data received.");

          unauthorize();
          return;
        }

        FitBitConst.usesr = userData[0] as FitbitAccountData;
        FitBitConst.usesrData.value = UserModel(
            age: FitBitConst.usesr!.age,
            bodyFat: 0,
            dateOfBirth: FitBitConst.usesr!.dateOfBirth,
            email: "",
            fullName: FitBitConst.usesr!.fullName,
            gender: FitBitConst.usesr!.gender,
            height: FitBitConst.usesr!.height,
            phoneNo: "",
            userID: FitBitConst.usesr!.userID,
            userName: "",
            weight: FitBitConst.usesr!.weight);
        await inst
            .collection("users")
            .doc(FitBitConst.usesr!.userID)
            .set(FitBitConst.usesrData.value.toMap());
        log("User Data: ${FitBitConst.usesr!.toJson()}");
      } else {
        FitBitConst.usesrData.value =
            UserModel.fromMap(userdata.docs[0].data());
      }
    } catch (e, stackTrace) {
      log("Error fetching profile: $e");

      log(stackTrace.toString());
      unauthorize();
    }
  }

  /// **Fetch Heart Rate Data**
  Future<void> fetchFitbitHeartRate({DateTime? date}) async {
    date ??= DateTime.now();
    // .subtract(Duration(days: 1));

    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null.");
        unauthorize();

        return;
      }

      FitbitHeartDataManager heartDataManager = FitbitHeartDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final List<FitbitData> heartData = await heartDataManager.fetch(
        FitbitHeartRateIntradayAPIURL.dayAndDetailLevel(
          date: date,
          intradayDetailLevel: IntradayDetailLevel.ONE_MINUTE,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );

      if (heartData.isEmpty) {
        log("Error: No heart rate data received.");
        unauthorize();
        return;
      }

      FitBitConst.heartRateData = heartData[0] as FitbitHeartRateData;
      log("Heart Data: ${FitBitConst.heartRateData!.toJson()}");
    } catch (e, stackTrace) {
      log("Error fetching heart rate: $e");
      log(stackTrace.toString());
      unauthorize();
    }
  }

  /// **Fetch Sleep Data**
  Future<void> fetchFitbitSleep({DateTime? date}) async {
    date ??= DateTime.now().subtract(Duration(days: 1));

    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null.");
        unauthorize();
        return;
      }

      FitbitSleepDataManager sleepDataManager = FitbitSleepDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final response = await sleepDataManager.getResponse(
        FitbitSleepAPIURL.day(
          date: date,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );
      //  log("Sleep data is ${response.toString()}");
      if (response == null || response.isEmpty) {
        log("Error: No sleep data received.");
        // unauthorize();
        return;
      }

      FitBitConst.sleepData = SleepResponse.fromMap(response);
      log("sleepresponse is ${response}");
      // FitBitConst.sleepstagesegment = parseSleepSegments(response);
      log("length is ${FitBitConst.sleepstagesegment!.length}");
      // log("Sleep Data: ${FitBitConst.sleepData.toString()}");
    } catch (e, stackTrace) {
      log("Error fetching sleep: $e");
      log(stackTrace.toString());
      // unauthorize();
    }
  }

  /// **Fetch Weekly Sleep Data**
  Future<void> fetchFitbitSleepWeekly() async {
    final controller = Homecontroller.to; // Get the controller instance

    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null.");
        unauthorize();
        return;
      }

      controller.loadchart.value = true; // Start loading

      // Initialize the list to store weekly sleep data
      FitBitConst.sleepWeaklyData = [];

      FitbitSleepDataManager sleepWeeklyDataManager = FitbitSleepDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      for (int v = 0; v < 7; v++) {
        final response = await sleepWeeklyDataManager.getResponse(
          FitbitSleepAPIURL.day(
            date: DateTime.now().subtract(Duration(days: v)),
            fitbitCredentials: FitBitConst.fitbitCredentials!,
          ),
        );

        if (response == null || response.isEmpty) {
          log("No sleep data found for day $v");
          continue; // Continue fetching other days' data
        }

        SleepResponse sleepData = SleepResponse.fromMap(response);
        double sleepHours = sleepData.summary.totalMinutesAsleep / 60;
        FitBitConst.sleepWeaklyData!.add(sleepHours);
      }

      log("Weekly Sleep Data: ${FitBitConst.sleepWeaklyData}");
    } catch (e, stackTrace) {
      log("Error fetching weekly sleep data: $e");
      log(stackTrace.toString());
      unauthorize();
    } finally {
      controller.loadchart.value = false; // Stop loading
    }
  }

  /// **Fetch Steps Data**
  Future<void> fetchFitbitSteps(
      {DateTime? startDate, DateTime? endDate}) async {
    startDate ??= DateTime.now();
    // .subtract(Duration(days: 1));
    endDate ??= DateTime.now();

    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null.");
        unauthorize();
        return;
      }

      FitbitActivityTimeseriesDataManager stepsDataManager =
          FitbitActivityTimeseriesDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final stepData = await stepsDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
          startDate: startDate,
          endDate: endDate,
          resource: Resource.steps,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );

      if (stepData.isEmpty) {
        log("Error: No step data received.");
        unauthorize();
        return;
      }

      FitBitConst.stepsdataList = stepData.cast<FitbitActivityTimeseriesData>();
      log("Steps Data: ${FitBitConst.stepsdataList.toString()}");
    } catch (e, stackTrace) {
      log("Error fetching steps: $e");
      log(stackTrace.toString());
      unauthorize();
    }
  }

  /// **Fetch Calories Data**
  Future<void> fetchFitbitCalories(
      {DateTime? startDate, DateTime? endDate}) async {
    startDate ??= DateTime.now();
    // .subtract(Duration(days: 1));
    endDate ??= DateTime.now();

    try {
      if (FitBitConst.fitbitCredentials == null) {
        log("Error: Fitbit credentials are null.");
        unauthorize();
        return;
      }

      FitbitActivityTimeseriesDataManager caloriesDataManager =
          FitbitActivityTimeseriesDataManager(
        clientID: Strings.fitbitClientID,
        clientSecret: Strings.fitbitClientSecret,
      );

      final calorieData = await caloriesDataManager.fetch(
        FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
          startDate: startDate,
          endDate: endDate,
          resource: Resource.calories,
          fitbitCredentials: FitBitConst.fitbitCredentials!,
        ),
      );

      if (calorieData.isEmpty) {
        log("Error: No calorie data received.");
        unauthorize();
        return;
      }

      FitBitConst.caloriesdataList =
          calorieData.cast<FitbitActivityTimeseriesData>();
      log("Calories Data: ${FitBitConst.caloriesdataList.toString()}");
    } catch (e, stackTrace) {
      log("Error fetching calories: $e");
      log(stackTrace.toString());
      unauthorize();
    }
  }

  /// Fetch Fitbit activities
  Future<List<dynamic>> fetchActivities(String startTime) async {
    try {
      final url = Uri.parse(
        'https://api.fitbit.com/1/user/-/activities/list.json?beforeDate=$startTime&sort=desc&offset=0&limit=100',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer ${FitBitConst.fitbitCredentials!.fitbitAccessToken}'
        },
      );

      if (response.statusCode == 200) {
//         DateTime today = DateTime.now(); // Get today's date
// DateTime todayStart = DateTime(today.year, today.month, today.day); // Start of today

        final data = json.decode(response.body);
        log("Fetching activities: ${response.body}");
        FitBitConst.activities = (data['activities'] as List)
            .map((json) => Activity.fromJson(json))
            .toList();
        //       FitBitConst.activities = FitBitConst.activities!
        // .where((activity) {
        //   DateTime activityDate = Formatesdates.getStartDateTime(startTime: activity.startTime);
        //   return activityDate.isAfter(todayStart) && activityDate.isBefore(todayStart.add(Duration(days: 1)));
        // })
        // .toList();

// FitBitConst.activities!.sort((a, b) =>
//     Formatesdates.getStartDateTime(startTime: b.startTime)
//         .compareTo(Formatesdates.getStartDateTime(startTime: a.startTime)));
        Activitycontroller.to.dropDownValue.value = FitBitConst.activities![0];
        FitBitConst.points.clear();
        // FitBitConst.points =
        fetchtodayActivity(date: DateTime.now());
        await fetchTCXData(FitBitConst.activities![0].logId.toString());

        List<ActivityDataPoint> dataPoints =
            FitBitConst.activities!.map((activity) {
          double avgHeartRate = activity.averageHeartRate ?? 0.0;
          String dominantActivityLevel = _getDominantActivityLevel(activity);

          return ActivityDataPoint(
            time: activity.startTime,
            averageHeartRate: avgHeartRate,
            activityLevel: dominantActivityLevel,
          );
        }).toList();
        FitBitConst.dataPoints = dataPoints;
        log("ACTIVITIES AVG IS : ${dataPoints.toString()}");
        return data['activities'] as List;
      } else {
        log("Error fetching activities: ${response.body}");
        return [];
      }
    } catch (e) {
      log("Exception in fetchActivities: $e");
      return [];
    }
  }

  fetchtodayActivity({required DateTime date}) async {
    FitBitConst.todayActivities = FitBitConst.activities!.where((activity) {
      DateTime activityDate =
          Formatesdates.getStartDateTime(startTime: activity.startTime);
      return activityDate.isAfter(date) &&
          activityDate.isBefore(date.add(Duration(days: 1)));
    }).toList();
    if (FitBitConst.todayActivities!.isNotEmpty) {
      Activitycontroller.to.dropDownValue.value =
          FitBitConst.todayActivities![0];
      await fetchTCXData(FitBitConst.todayActivities![0].logId.toString());

      Activitycontroller.to.isActivityFound.value = true;
    } else {
      Activitycontroller.to.isActivityFound.value = false;
    }
    await initializeMap();
  }

  static String _getDominantActivityLevel(Activity activity) {
    if (activity.activityLevels == null || activity.activityLevels!.isEmpty) {
      return "Unknown";
    }

    return activity.activityLevels!
        .reduce((a, b) => a.duration > b.duration ? a : b)
        .name;
  }

  /// Recursively fetch all running activities
  static Future<List<dynamic>> fetchAllRuns(String startTime) async {
    List<dynamic> runs = [];
    log("Fetching activities from: $startTime");

    // List<dynamic> events = await fetchActivities(startTime);

    if (events!.isEmpty) return runs;

    for (var event in events!) {
      if (event['activityName'] == 'Walk') {
        if (event['logType'] == 'tracker') {
          log("Run Found: ${event['logId']}");
          runs.add(event);
        }
      }
    }

    if (events!.isNotEmpty) {
      String newStartTime = events!.last['startTime'].substring(0, 10);
      List<dynamic> moreRuns = await fetchAllRuns(newStartTime);
      runs.addAll(moreRuns);
    }

    return runs;
  }

  /// Fetch TCX data (DOES NOT SAVE, JUST PARSES)

  // Observable loading state

  static Future<List<LatLng>> fetchTCXData(String logId) async {
    FitBitConst.points.clear();
    try {
      Activitycontroller.to.isLoadingmap.value = true; // Start loading
      final url = Uri.parse(
        'https://api.fitbit.com/1/user/${FitBitConst.fitbitCredentials!.userID}/activities/$logId.tcx',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer ${FitBitConst.fitbitCredentials!.fitbitAccessToken}',
        },
      );

      if (response.statusCode == 200) {
        log("Parsing TCX data for Log ID: $logId");
        final document = xml.XmlDocument.parse(response.body);
        final trackpoints = document.findAllElements("Trackpoint");

        if (trackpoints.isEmpty) {
          log("No trackpoints found in TCX for Log ID: $logId");
          return FitBitConst.points;
        }

        for (var trackpoint in trackpoints) {
          double? lat, lon;

          // Check if GPS is inside the <Position> tag
          final position = trackpoint.findElements("Position");
          if (position.isNotEmpty) {
            final latElements = position.first.findElements("LatitudeDegrees");
            final lonElements = position.first.findElements("LongitudeDegrees");

            if (latElements.isNotEmpty && lonElements.isNotEmpty) {
              lat = double.tryParse(latElements.first.text);
              lon = double.tryParse(lonElements.first.text);
            }
          }

          // If not inside <Position>, check directly in <Trackpoint>
          if (lat == null || lon == null) {
            final latElements = trackpoint.findElements("LatitudeDegrees");
            final lonElements = trackpoint.findElements("LongitudeDegrees");

            if (latElements.isNotEmpty && lonElements.isNotEmpty) {
              lat = double.tryParse(latElements.first.text);
              lon = double.tryParse(lonElements.first.text);
            }
          }

          // If valid lat/lon found, add to list
          if (lat != null && lon != null) {
            FitBitConst.points.add(LatLng(lat, lon));
          } else {
            log("Skipping Trackpoint: Missing Latitude/Longitude in Log ID: $logId");
          }
        }
      } else {
        log("Error fetching TCX for Log ID $logId: ${response.body}");
      }
    } catch (e) {
      log("Exception in fetchTCXData: $e");
    } finally {
      Activitycontroller.to.isLoadingmap.value = false; // Stop loading
    }

    return FitBitConst.points;
  }

  ///MAP

  Future<void> initializeMap() async {
    Activitycontroller.to.isLoadingmap.value = true;
    await loadCustommarkers();
    await loadTCXData();
    Activitycontroller.to.isLoadingmap.value = false;
  }

  /// Load custom circular FitBitConst.markers
  Future<void> loadCustommarkers() async {
    FitBitConst.startMarkerIcon =
        await createCircularMarker(AppColors.primaryColor);
    FitBitConst.endMarkerIcon =
        await createCircularMarker(AppColors.primaryColor);
  }

  /// Create a **small circular** marker icon
  Future<BitmapDescriptor> createCircularMarker(Color color) async {
    double size = 20.sp; // Set smaller size

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    final ui.Image img =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  /// Fetch and parse TCX data
  Future<void> loadTCXData() async {
    // FitBitConst.points.clear(); // Clear existing points
    // FitBitConst.points = FitBitConst.points; // Fetching points from FitBitConst
    FitBitConst.polylines.clear();
    FitBitConst.markers.clear();
    log("Fetched GPS Points: ${FitBitConst.points.length}");

    if (FitBitConst.points.isNotEmpty) {
      // Add polyline
      FitBitConst.polylines.add(
        Polyline(
          polylineId: const PolylineId("Route_path"),
          points: FitBitConst.points,
          color: Colors.black,
          width: 5,
        ),
      );

      // Add start and end FitBitConst.markers with small size
      FitBitConst.markers.add(
        Marker(
          markerId: const MarkerId("start"),
          position: FitBitConst.points.first,
          icon: FitBitConst.startMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: "Start Point"),
        ),
      );

      FitBitConst.markers.add(
        Marker(
          markerId: const MarkerId("end"),
          position: FitBitConst.points.last,
          icon: FitBitConst.endMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: "End Point"),
        ),
      );

      // Auto zoom to fit the polyline
      autoZoomToPolyline();
      FitBitConst.totalDistance = calculateTotalDistance();
    }
  }

  /// Auto-zoom to fit all FitBitConst.markers and polyline
  void autoZoomToPolyline() {
    if (FitBitConst.mapController == null || FitBitConst.points.isEmpty) return;

    FitBitConst.mapController!.getVisibleRegion().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LatLngBounds bounds = getLatLngBounds();

        // Ensure bounds are valid
        if (bounds.southwest != bounds.northeast) {
          FitBitConst.mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50),
          );
        } else {
          print("Skipping animateCamera: Invalid bounds");
        }
      });
    }).catchError((error) {
      print("Error getting visible region: $error");
    });
  }

  /// Calculate bounds for the route
  LatLngBounds getLatLngBounds() {
    double minLat = FitBitConst.points
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = FitBitConst.points
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = FitBitConst.points
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = FitBitConst.points
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    if (minLat == maxLat && minLng == maxLng) {
      // Adjust slightly to create a valid bounding box
      minLat -= 0.0005;
      maxLat += 0.0005;
      minLng -= 0.0005;
      maxLng += 0.0005;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Calculate total distance from `FitBitConst.points` list
  double calculateTotalDistance() {
    if (FitBitConst.points.isEmpty) return 0.0;

    double totalDistance = 0.0;

    for (int i = 0; i < FitBitConst.points.length - 1; i++) {
      totalDistance += calculateDistance(
        FitBitConst.points[i],
        FitBitConst.points[i + 1],
      );
    }
    return totalDistance; // Distance in kilometers
  }

  /// Calculate distance between two LatLng points using Haversine formula
  double calculateDistance(LatLng start, LatLng end) {
    const double R = 6371; // Earth's radius in km
    double lat1 = start.latitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double deltaLat = (end.latitude - start.latitude) * math.pi / 180;
    double deltaLng = (end.longitude - start.longitude) * math.pi / 180;

    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c; // Distance in km
  }
}
