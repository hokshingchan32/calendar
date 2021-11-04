import 'package:intl/intl.dart';

class Util {
  static String getFormattedDateTimeString(DateTime dateTime, String format) {
    final formatter = DateFormat(format, 'ja_JP');
    return formatter.format(dateTime);
  }

  static DateTime getDateTimeFromString(String string, String format) {
    final formatter = DateFormat(format, 'ja_JP');
    return formatter.parseLoose(string);
  }

  /// 15分区切りの時間を返す
  static DateTime roundWithFifteen(DateTime? d) {
    var date = d ?? DateTime.now();

    final int deltaMinute;
    if (date.minute == 0) {
      deltaMinute = 0;
    } else if (date.minute <= 15) {
      deltaMinute = 15 - date.minute;
    } else if (date.minute <= 30) {
      deltaMinute = 30 - date.minute;
    } else if (date.minute <= 45) {
      deltaMinute = 45 - date.minute;
    } else {
      deltaMinute = 60 - date.minute;
    }

    return date.add(
      Duration(
        minutes: deltaMinute,
        seconds: -date.second,
        microseconds: -date.microsecond,
        milliseconds: -date.millisecond,
      ),
    );
  }
}
