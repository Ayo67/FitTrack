import 'package:FitTrack/src/repository/sleep_model.dart';
import 'package:fitbitter/fitbitter.dart';

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
  static List<FitbitActivityTimeseriesData>? stepsdataList;
  static List<FitbitActivityTimeseriesData>? caloriesdataList;
  static FitbitCredentials? fitbitCredentials;
}
