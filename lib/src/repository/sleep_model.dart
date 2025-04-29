// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  SleepData copyWith({
    String? dateOfSleep,
    int? duration,
    int? efficiency,
    String? endTime,
    bool? isMainSleep,
    List<SleepLevel>? levels,
    int? minutesAsleep,
    int? minutesAwake,
    int? timeInBed,
    String? type,
  }) {
    return SleepData(
      dateOfSleep: dateOfSleep ?? this.dateOfSleep,
      duration: duration ?? this.duration,
      efficiency: efficiency ?? this.efficiency,
      endTime: endTime ?? this.endTime,
      isMainSleep: isMainSleep ?? this.isMainSleep,
      levels: levels ?? this.levels,
      minutesAsleep: minutesAsleep ?? this.minutesAsleep,
      minutesAwake: minutesAwake ?? this.minutesAwake,
      timeInBed: timeInBed ?? this.timeInBed,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateOfSleep': dateOfSleep,
      'duration': duration,
      'efficiency': efficiency,
      'endTime': endTime,
      'isMainSleep': isMainSleep,
      'levels': levels.map((x) => x.toMap()).toList(),
      'minutesAsleep': minutesAsleep,
      'minutesAwake': minutesAwake,
      'timeInBed': timeInBed,
      'type': type,
    };
  }

  factory SleepData.fromMap(Map<String, dynamic> map) {
    return SleepData(
      dateOfSleep: map['dateOfSleep'] as String,
      duration: map['duration'] as int,
      efficiency: map['efficiency'] as int,
      endTime: map['endTime'] as String,
      isMainSleep: map['isMainSleep'] as bool,
      levels: map['levels'] is List
          ? List<SleepLevel>.from(
              (map['levels'] as List<dynamic>).map<SleepLevel>(
                (x) => SleepLevel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [], // Default to an empty list if levels is not a list
      minutesAsleep: map['minutesAsleep'] as int,
      minutesAwake: map['minutesAwake'] as int,
      timeInBed: map['timeInBed'] as int,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SleepData.fromJson(String source) =>
      SleepData.fromMap(json.decode(source) as Map<String, dynamic>);
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateTime': dateTime,
      'level': level,
      'seconds': seconds,
    };
  }

  factory SleepLevel.fromMap(Map<String, dynamic> map) {
    return SleepLevel(
      dateTime: map['dateTime'] as String,
      level: map['level'] as String,
      seconds: map['seconds'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SleepLevel.fromJson(String source) =>
      SleepLevel.fromMap(json.decode(source) as Map<String, dynamic>);
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalMinutesAsleep': totalMinutesAsleep,
      'totalSleepRecords': totalSleepRecords,
      'totalTimeInBed': totalTimeInBed,
    };
  }

  factory SleepSummary.fromMap(Map<String, dynamic> map) {
    return SleepSummary(
      totalMinutesAsleep: map['totalMinutesAsleep'] as int,
      totalSleepRecords: map['totalSleepRecords'] as int,
      totalTimeInBed: map['totalTimeInBed'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SleepSummary.fromJson(String source) =>
      SleepSummary.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SleepResponse {
  final List<SleepData> sleep;
  final SleepSummary summary;

  SleepResponse({
    required this.sleep,
    required this.summary,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sleep': sleep.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory SleepResponse.fromMap(Map<String, dynamic> map) {
    return SleepResponse(
      sleep: map['sleep'] is List
          ? List<SleepData>.from(
              (map['sleep'] as List<dynamic>).map<SleepData>(
                (x) => SleepData.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [], // Default to an empty list if 'sleep' is not a List
      summary: SleepSummary.fromMap(map['summary'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SleepResponse.fromJson(String source) =>
      SleepResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SleepStageSegment {
  final String stage;
  final int startMinute;
  final int durationMinutes;

  SleepStageSegment({
    required this.stage,
    required this.startMinute,
    required this.durationMinutes,
  });

  @override
  String toString() {
    return 'SleepStageSegment(stage: "$stage", startMinute: $startMinute, durationMinutes: $durationMinutes)';
  }
}

List<SleepStageSegment> parseSleepSegments(Map<String, dynamic> sleepData) {
  final sleepList = sleepData['sleep'] as List;
  if (sleepList == null || sleepList.isEmpty) {
    throw Exception('No sleep data found.');
  }
  final mainSleep = sleepList.firstWhere(
    (s) => s['isMainSleep'] == true,
    orElse: () => null,
  );
  if (mainSleep == null) {
    throw Exception('No main sleep found.');
  }
  final levels = mainSleep['levels']['data'] as List;
  final startTime = DateTime.parse(mainSleep['startTime']);

  return levels.map((entry) {
    final stage = entry['level'].toString().toUpperCase();
    final dateTime = DateTime.parse(entry['dateTime']);
    final seconds = entry['seconds'] as int;
    final startMinute = dateTime.difference(startTime).inMinutes;
    final durationMinutes = (seconds / 60).round();

    return SleepStageSegment(
      stage: stage == 'WAKE'
          ? 'Awake'
          : stage[0] + stage.substring(1).toLowerCase(),
      startMinute: startMinute,
      durationMinutes: durationMinutes,
    );
  }).toList();
}
