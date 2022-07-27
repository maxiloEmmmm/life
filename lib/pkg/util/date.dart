String wrapIfLt10(int num) {
  return "${num < 10 ? "0$num" : num}";
}

int diffDay(DateTime start, end) {
  return DateTime.parse("${end.year}-${wrapIfLt10(end.month)}-${wrapIfLt10(end.day)}").difference(DateTime.parse("${start.year}-${wrapIfLt10(start.month)}-${wrapIfLt10(start.day)}")).inDays;
}

int diffWeek(DateTime start, end) {
  var dw = (diffDay(start, end) / 7).ceil();
  return dw == 0 ? 1 : dw;
}