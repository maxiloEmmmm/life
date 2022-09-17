part of 'db.dart';

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
    DBMetaField(name: "count", type: DBFieldType.Int, defaultDefine: "1"),
    DBMetaField(name: "notBefore", type: DBFieldType.DateTime),
    DBMetaField(name: "notAfter", type: DBFieldType.DateTime),
    DBMetaField(
        name: "createdAt",
        type: DBFieldType.DateTime,
        defaultDefine: "DateTime.now()"),
  ],
  edges: [
    DBMetaEdge(table: "HabitRecord", type: DBEdgeType.To),
  ],
)
class Habit {}

class HabitTimeRange {
  List<tz.TZDateTime> ss = [];
  int current = 0;
}

extension HabitTypeHelp on HabitType {
  HabitTimeRange get timeRange {
    var dr = notAfter!.difference(notBefore!).inMinutes / (count! + 1);
    var now = tz.TZDateTime.now(tz.local);
    int c = count!;
    var ret = HabitTimeRange();
    var today = todayTime(notBefore!);
    for (var i = 1; i <= c; i++) {
      var tt = today.add(Duration(minutes: dr.toInt() * i));
      if (diffMinute(now, tt) <= 0) {
        ret.current++;
      }
      ret.ss.add(tz.TZDateTime(
          tz.local, tt.year, tt.month, tt.day, tt.hour, tt.minute, tt.second));
    }
    return ret;
  }

  Future<int> dayHad() async {
    var hrs = await clientSet.HabitRecord()
        .query()
        .where(Eq(HabitRecordClient.Habit_refField, id))
        .query();

    return hrs
        .where((element) => diffDay(element.createdAt!, DateTime.now()) == 0)
        .length;
  }
}
