
  import 'package:intl/intl.dart';
class Formatesdates{
  
/// Convert `startTime` to DateTime
static  DateTime getStartDateTime({required String startTime}) {
    return DateTime.parse(startTime);
  }

  /// Calculate `endTime` by adding duration
static  DateTime getEndDateTime({required String startTime,required int duration}) {
    return getStartDateTime(startTime: startTime).add(Duration(milliseconds: duration));

  }

  /// Format time as "3 Mar 25  3:30 AM"
 static String formatDateTime(DateTime dateTime) {
    return DateFormat("d MMM yy  h:mm a").format(dateTime);
  }

  /// Get Start Time in required format
 static String getFormattedStartTime({required String startTime}) {
    return formatDateTime(getStartDateTime(startTime: startTime));
  }

  /// Get End Time in required format
 static String getFormattedEndTime({required String startTime, required int duration}) {
    return formatDateTime(getEndDateTime(duration: duration,startTime: startTime));
  }

  /// Get Duration as "1 h 30 min" or "30 min 20 sec"
 static String getFormattedDuration({ required int duration}) {
    int totalSeconds = duration ~/ 1000;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0 && minutes > 0) {
      return "$hours h $minutes min";
    } else if (hours > 0) {
      return "$hours h";
    } else if (minutes > 0 && seconds > 0) {
      return "$minutes min $seconds sec";
    } else {
      return "$minutes min";
    }
  }
static String getFormattedDurationMinutes({required int minutes}) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  if (hours > 0 && remainingMinutes > 0) {
    return "$hours h $remainingMinutes min";
  } else if (hours > 0) {
    return "$hours h";
  } else {
    return "$remainingMinutes min";
  }
}

}