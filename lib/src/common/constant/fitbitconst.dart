import 'package:fitbitter/fitbitter.dart';
import 'package:fitnessapp/src/repository/avg_heartrate_model.dart';
import 'package:fitnessapp/src/repository/sleep_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FitBitConst {
  static final List<FitbitAuthScope> scopeList = [
    FitbitAuthScope.PROFILE,
    FitbitAuthScope.OXYGEN_SATURATION,
    FitbitAuthScope.SLEEP,
    FitbitAuthScope.HEART_RATE,
    FitbitAuthScope.ACTIVITY,
    FitbitAuthScope.LOCATION,
  ];
  static FitbitAccountData? usesr;
  static FitbitHeartRateData? heartRateData;
  static SleepResponse? sleepData;
  static List<double>? sleepWeaklyData;
  static List<FitbitActivityTimeseriesData>? stepsdataList;
  static List<FitbitActivityTimeseriesData>? caloriesdataList;
  static FitbitCredentials? fitbitCredentials;
  static List<Activity>? activities;
  static List<Activity>? todayActivities;
  static List<ActivityDataPoint>? dataPoints;

  static List<FlSpot> heartRateSpots = [];
  static List<FlSpot> activityLevelSpots = [];
  // MAp
  static List<LatLng> points = [];
  static final Set<Polyline> polylines = {};
  static final Set<Marker> markers = {};
  static BitmapDescriptor? startMarkerIcon;
  static BitmapDescriptor? endMarkerIcon;
  static GoogleMapController? mapController;
  static double? totalDistance;


}
