import 'package:timezone/timezone.dart' as tz;

String wrapIfLt10(int num) {
  return "${num < 10 ? "0$num" : num}";
}

int diffDay(DateTime start, DateTime end) {
  return DateTime.parse(
          "${end.year}-${wrapIfLt10(end.month)}-${wrapIfLt10(end.day)}")
      .difference(DateTime.parse(
          "${start.year}-${wrapIfLt10(start.month)}-${wrapIfLt10(start.day)}"))
      .inDays;
}

DateTime todayTime(DateTime t) {
  var n = tz.TZDateTime.now(tz.local);
  return DateTime.parse(
      "${n.year}-${wrapIfLt10(n.month)}-${wrapIfLt10(n.day)} ${wrapIfLt10(t.hour)}:${wrapIfLt10(t.minute)}:${wrapIfLt10(t.second)}");
}

int diffWeek(DateTime start, DateTime end) {
  return ((diffDay(start, end) + 1) / 7).ceil();
}

int diffMinute(DateTime start, DateTime end) {
  int s = start.minute + start.hour * 60;
  int e = end.minute + end.hour * 60;
  return e - s;
}
