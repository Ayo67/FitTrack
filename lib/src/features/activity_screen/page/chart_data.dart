import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  Map<String, double> activityLevelMap = {
  'sedentary': 60.0,
  'lightly': 80.0,
  'fairly': 100.0,
  'Good': 150.0,
};

// Convert data to FlSpots

convert( activityData){
  FitBitConst.activityLevelSpots.clear();
  FitBitConst.heartRateSpots.clear();
for (int i = 0; i <activityData.length/3 ; i++) {
  double xValue = i.toDouble(); 
 FitBitConst. heartRateSpots.add(FlSpot(xValue, activityData[i].averageHeartRate));
  FitBitConst.activityLevelSpots.add(
      FlSpot(xValue, activityLevelMap[activityData[i].activityLevel] ?? 0));
}}
}