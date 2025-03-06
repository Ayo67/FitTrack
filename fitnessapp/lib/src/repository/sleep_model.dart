class SleepData {
  final String dateOfSleep;
  final int duration;
  final int efficiency;
  final String endTime;
  final bool isMainSleep;
  final List<SleepLevel> levels;
  final int minutesAsleep;
  final int minutesAwake;
  final int timeInBed;
  final String type;

  SleepData({
    required this.dateOfSleep,
    required this.duration,
    required this.efficiency,
    required this.endTime,
    required this.isMainSleep,
    required this.levels,
    required this.minutesAsleep,
    required this.minutesAwake,
    required this.timeInBed,
    required this.type,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      dateOfSleep: json['dateOfSleep'],
      duration: json['duration'],
      efficiency: json['efficiency'],
      endTime: json['endTime'],
      isMainSleep: json['isMainSleep'],
      levels: (json['levels']['data'] as List)
          .map((e) => SleepLevel.fromJson(e))
          .toList(),
      minutesAsleep: json['minutesAsleep'],
      minutesAwake: json['minutesAwake'],
      timeInBed: json['timeInBed'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateOfSleep': dateOfSleep,
      'duration': duration,
      'efficiency': efficiency,
      'endTime': endTime,
      'isMainSleep': isMainSleep,
      'levels': {'data': levels.map((e) => e.toJson()).toList()},
      'minutesAsleep': minutesAsleep,
      'minutesAwake': minutesAwake,
      'timeInBed': timeInBed,
      'type': type,
    };
  }
}

class SleepLevel {
  final String dateTime;
  final String level;
  final int seconds;

  SleepLevel({
    required this.dateTime,
    required this.level,
    required this.seconds,
  });

  factory SleepLevel.fromJson(Map<String, dynamic> json) {
    return SleepLevel(
      dateTime: json['dateTime'],
      level: json['level'],
      seconds: json['seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime,
      'level': level,
      'seconds': seconds,
    };
  }
}

class SleepSummary {
  final int totalMinutesAsleep;
  final int totalSleepRecords;
  final int totalTimeInBed;

  SleepSummary({
    required this.totalMinutesAsleep,
    required this.totalSleepRecords,
    required this.totalTimeInBed,
  });

  factory SleepSummary.fromJson(Map<String, dynamic> json) {
    return SleepSummary(
      totalMinutesAsleep: json['totalMinutesAsleep'],
      totalSleepRecords: json['totalSleepRecords'],
      totalTimeInBed: json['totalTimeInBed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMinutesAsleep': totalMinutesAsleep,
      'totalSleepRecords': totalSleepRecords,
      'totalTimeInBed': totalTimeInBed,
    };
  }
}

class SleepResponse {
  final List<SleepData> sleep;
  final SleepSummary summary;

  SleepResponse({
    required this.sleep,
    required this.summary,
  });

  factory SleepResponse.fromJson(Map<String, dynamic> json) {
    return SleepResponse(
      sleep: (json['sleep'] as List).map((e) => SleepData.fromJson(e)).toList(),
      summary: SleepSummary.fromJson(json['summary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleep': sleep.map((e) => e.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}
