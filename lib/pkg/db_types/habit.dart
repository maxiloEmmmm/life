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

extension HabitTypeHelp on HabitType {
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
