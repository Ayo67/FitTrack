// ignore_for_file: public_member_api_docs, sort_constructors_first
class Activity {
  final String startTime;
  final String? activityName;
  final double? averageHeartRate;
  final List<ActivityLevel>? activityLevels;
  final int? originalDuration;
  final int? calories;
  final int? logId;

  Activity({
    required this.startTime,
    this.averageHeartRate,
    this.activityLevels,
    this.originalDuration,
    this.logId,
    this.calories,
    this.activityName,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      startTime: json['startTime'] ?? '',
      activityName: json['activityName'] ?? '',
      averageHeartRate: (json['averageHeartRate'] as num?)?.toDouble(),
      originalDuration: (json['originalDuration'] as int?) ?? 0,
      logId: (json['logId'] as int?) ?? 0,
      calories: (json['calories'] as int?) ?? 0,
      activityLevels: json['activityLevel'] != null
          ? (json['activityLevel'] as List)
              .map((level) => ActivityLevel.fromJson(level))
              .toList()
          : [],
    );
  }
}

class ActivityLevel {
  final String name;
  final int duration; // Duration in milliseconds

  ActivityLevel({
    required this.name,
    required this.duration,
  });

  factory ActivityLevel.fromJson(Map<String, dynamic> json) {
    return ActivityLevel(
      name: json['name'] ?? 'Unknown',
      duration: json['minutes'] ?? 0,
    );
  }
}

/// Data model for graph plotting
class ActivityDataPoint {
  final String time;
  final double averageHeartRate;
  final String activityLevel;

  ActivityDataPoint({
    required this.time,
    required this.averageHeartRate,
    required this.activityLevel,
  });

  @override
  String toString() =>
      'ActivityDataPoint(time: $time, averageHeartRate: $averageHeartRate, activityLevel: $activityLevel)';
}
