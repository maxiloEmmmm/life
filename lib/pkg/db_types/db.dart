import 'package:focus/pkg/util/date.dart';
import 'package:timezone/timezone.dart' as tz;
import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
part 'db.db.g.dart';
part 'plan.dart';
part 'habit.dart';

@DBSchema(
  fields: [
    DBMetaField(name: "identity"),
    DBMetaField(name: "apiKey"),
  ],
)
class Ngrok {}

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
  ],
  edges: [
    DBMetaEdge(table: "Plan", type: DBEdgeType.To),
    DBMetaEdge(table: "Thing", type: DBEdgeType.To, unique: true),
  ],
)
class Award {}

@DBSchema(
  fields: [
    DBMetaField(name: "hit", type: DBFieldType.Int),
    DBMetaField(name: "desc"),
    DBMetaField(name: "createdAt", type: DBFieldType.DateTime),
  ],
  edges: [
    DBMetaEdge(table: "Plan", type: DBEdgeType.From, unique: true),
  ],
)
class PlanDetail {}

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
  ],
  edges: [
    DBMetaEdge(table: "Award", type: DBEdgeType.From),
  ],
)
class Thing {}

@DBSchema(
  fields: [
    DBMetaField(
        name: "createdAt",
        type: DBFieldType.DateTime,
        defaultDefine: "DateTime.now()"),
  ],
  edges: [
    DBMetaEdge(table: "Habit", type: DBEdgeType.From, unique: true),
  ],
)
class HabitRecord {}
